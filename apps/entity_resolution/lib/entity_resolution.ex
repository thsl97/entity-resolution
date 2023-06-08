defmodule EntityResolution do
  alias EntityResolution.Algorithms.LeastConnections
  alias EntityResolution.Algorithms.ResponseTime
  alias EntityResolution.Algorithms.WeightedLeastConnections

  def run(file_path, chunk_sizes) do
    file_path
    |> File.stream!()
    |> chunk(chunk_sizes)
    |> Stream.map(fn chunk ->
      Task.async(fn ->
        algorithm = Application.fetch_env!(:entity_resolution, :algorithm)

        node = algorithm.get_next_server()

        :telemetry.execute([:router], %{total_requests: 1}, %{node: node})

        :telemetry.execute([:router], %{chunk_size: length(chunk)}, %{node: node})

        case algorithm do
          ResponseTime ->
            {result, time} =
              :rpc.call(node, EntityResolutionWorker, :resolve_entities, [chunk])

            ResponseTime.update_response_time(node, time)
            result

          module when module in [LeastConnections, WeightedLeastConnections] ->
            {result, _} =
              :rpc.call(node, EntityResolutionWorker, :resolve_entities, [chunk])

            module.free_connection(node)
            result

          _ ->
            {result, _} =
              :rpc.call(node, EntityResolutionWorker, :resolve_entities, [chunk])

            result
        end
      end)
    end)
    |> Enum.to_list()
    |> Task.await_many(:infinity)
    |> List.flatten()
  end

  defp chunk(stream, chunk_sizes) when is_list(chunk_sizes) do
    do_chunk(stream, chunk_sizes, [])
  end

  defp chunk(stream, chunk_size) do
    Stream.chunk_every(stream, chunk_size)
  end

  defp do_chunk(stream, [chunk_size], acc) do
    stream |> Stream.chunk_every(chunk_size) |> Enum.to_list() |> Kernel.++(acc) |> Enum.reverse()
  end

  defp do_chunk(stream, [size | rest], acc) do
    head = stream |> Stream.take(size) |> Enum.to_list()
    IO.puts("chunk size #{length(head)}")
    tail = Stream.drop(stream, size)
    do_chunk(tail, rest, [head] ++ acc)
  end
end
