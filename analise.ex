data
|> Enum.map(fn {algorithm,
                %{
                  worst_case: %{count: count, execution_time: execution_time, metrics: metrics}
                }} ->
  execution_times_per_worker =
    Enum.map(metrics, fn {worker, %{execution_times: execution_times}} ->
      {worker, %{average: Enum.sum(execution_times) / length(execution_times)},
       max: Enum.max(execution_times), min: Enum.min(execution_times)}
    end)

  blocks_per_worker =
    Enum.map(metrics, fn {worker, %{total_blocks: total_blocks}} ->
      {worker, total_blocks}
    end)

  largest_blocks =
    Enum.map(metrics, fn {worker, %{chunk_sizes: chunk_sizes}} ->
      {worker, chunk_sizes |> Enum.sort() |> Enum.take(-5) |> Enum.reverse()}
    end)

  {algorithm,
   %{
     blocks_per_worker: blocks_per_worker,
     count: count,
     execution_time: execution_time,
     execution_times_per_worker: execution_times_per_worker,
     largest_blocks: largest_blocks
   }}
end)
