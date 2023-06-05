defmodule EntityResolution do
  alias EntityResolution.Algorithms.LeastConnections
  alias EntityResolution.Algorithms.ResponseTime
  alias EntityResolution.Algorithms.WeightedLeastConnections

  def run(file_path, chunk_sizes) do
    env = Application.fetch_env!(:load_balancer, :env)

    file_path
    |> File.stream!()
    |> chunk(chunk_sizes)
    |> Task.async_stream(
      fn chunk ->
        Task.async(fn ->
          case env do
            :prod ->
              run_distributed(chunk)

            _ ->
              EntityResolution.Worker.resolve_entities(chunk)
          end
        end)
      end,
      max_concurrency: max_concurrency(:env)
    )
    |> Enum.to_list()
    |> Task.await_many(:infinity)
    |> List.flatten()
  end

  defp chunk(stream, chunk_sizes) when is_list(chunk_sizes) do
    Stream.chunk_while(
      stream,
      {0, []},
      fn
        elem, {index, acc} when length(chunk_sizes) - 1 == index ->
          chunk_length = Enum.at(chunk_sizes, index)

          if length(acc) == chunk_length - 1 do
            {:cont, Enum.reverse([elem | acc]), {0, []}}
          else
            {:cont, {index, [elem | acc]}}
          end

        elem, {index, acc} ->
          chunk_length = Enum.at(chunk_sizes, index)

          if length(acc) == chunk_length - 1 do
            {:cont, Enum.reverse([elem | acc]), {index + 1, []}}
          else
            {:cont, {index, [elem | acc]}}
          end
      end,
      fn
        {_index, []} -> {:cont, []}
        {_index, acc} -> {:cont, Enum.reverse(acc), []}
      end
    )
  end

  defp chunk(stream, chunk_size) do
    Stream.chunk_every(stream, chunk_size)
  end

  defp run_distributed(chunk) do
    algorithm = algorithm()

    node = algorithm.get_next_server()

    :telemetry.execute([:router], %{total_requests: 1}, %{node: node})

    :telemetry.execute([:router], %{chunk_size: length(chunk)}, %{node: node})

    case algorithm do
      ResponseTime ->
        {time, result} = call_remote_node(node, chunk)

        ResponseTime.update_response_time(node, time)
        result

      module when module in [LeastConnections, WeightedLeastConnections] ->
        {_time, result} = call_remote_node(node, chunk)

        module.free_connection(node)
        result

      _ ->
        {_, result} = call_remote_node(node, chunk)
        result
    end
  end

  defp algorithm do
    Application.fetch_env!(:load_balancer, :algorithm)
  end

  defp call_remote_node(node, chunk) do
    {time, _} =
      result =
      :timer.tc(fn -> :rpc.call(node, EntityResolution.Worker, :resolve_entities, [chunk]) end)

    :telemetry.execute([:router], %{execution_time: time / 1_000_000}, %{node: node})

    result
  end

  defp max_concurrency(:prod) do
    :load_balancer
    |> Application.fetch_env!(:workers)
    |> Enum.map(fn {_k, v} -> v end)
    |> Enum.sum()
  end

  defp max_concurrency(_) do
    System.schedulers_online()
  end
end
