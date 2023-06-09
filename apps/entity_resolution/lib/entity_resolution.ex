defmodule EntityResolution do
  alias EntityResolution.Algorithms.LeastConnections
  alias EntityResolution.Algorithms.ResponseTime
  alias EntityResolution.Algorithms.WeightedLeastConnections

  def run(file_path, chunk_sizes) do
    {:ok, agent} = start_agent()

    chunks =
      file_path
      |> File.stream!()
      |> chunk(chunk_sizes)

    start_time = System.monotonic_time(:millisecond)

    result =
      chunks
      |> Task.async_stream(
        fn
          chunk when length(chunk) > 1 ->
            algorithm = Application.fetch_env!(:entity_resolution, :algorithm)

            node = algorithm.get_next_server()
            chunk_size = length(chunk)

            :telemetry.execute([:router], %{chunk_size: chunk_size, total_requests: 1}, %{
              node: node
            })

            {result, time} =
              case algorithm do
                ResponseTime ->
                  {_, time} =
                    result =
                    :rpc.call(node, EntityResolutionWorker, :resolve_entities, [chunk], :infinity)

                  ResponseTime.update_response_time(node, time)
                  result

                module when module in [LeastConnections, WeightedLeastConnections] ->
                  result =
                    :rpc.call(node, EntityResolutionWorker, :resolve_entities, [chunk], :infinity)

                  module.free_connection(node)
                  result

                _ ->
                  result =
                    :rpc.call(node, EntityResolutionWorker, :resolve_entities, [chunk], :infinity)

                  result
              end

            Agent.update(agent, fn state ->
              state
              |> update_in([node, :execution_times], fn list -> [time] ++ list end)
              |> update_in([node, :chunk_sizes], fn list -> [chunk_size] ++ list end)
              |> update_in([node, :total_blocks], &(&1 + 1))
            end)

            :telemetry.execute([:router], %{execution_time: time}, %{node: node})
            result

          chunk ->
            chunk
        end,
        max_concurrency: max_concurrency(),
        timeout: :infinity
      )
      |> Enum.map(fn {:ok, result} -> result end)
      |> List.flatten()

    execution_time = System.monotonic_time(:millisecond) - start_time

    %{
      execution_time: execution_time,
      count: length(result),
      metrics: Agent.get(agent, fn state -> state end)
    }
  end

  defp chunk(stream, chunk_sizes) when is_list(chunk_sizes) do
    Stream.chunk_while(
      stream,
      {[], chunk_sizes},
      fn elem, {acc, [chunk_size | rest] = chunk_sizes} ->
        if length(acc) == chunk_size - 1 do
          {:cont, Enum.reverse([elem | acc]), {[], rest ++ [chunk_size]}}
        else
          {:cont, {[elem | acc], chunk_sizes}}
        end
      end,
      fn
        [] -> {:cont, []}
        {acc, _} -> {:cont, Enum.reverse(acc), []}
      end
    )
  end

  defp chunk(stream, chunk_size) do
    Stream.chunk_every(stream, chunk_size)
  end

  defp max_concurrency do
    :entity_resolution
    |> Application.fetch_env!(:workers)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  defp start_agent do
    state =
      :entity_resolution
      |> Application.fetch_env!(:workers)
      |> Enum.map(fn {k, _} ->
        %{k => %{chunk_sizes: [], execution_times: [], total_blocks: 0}}
      end)
      |> Enum.reduce(%{}, &Map.merge/2)

    Agent.start_link(fn -> state end)
  end
end
