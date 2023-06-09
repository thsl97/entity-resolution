defmodule DecreasingList do
  def generate_decreasing_list(number, percentage)
      when number > 0 and percentage >= 0.0 and percentage <= 100.0 do
    generate_decreasing_list(number, percentage, [])
  end

  defp generate_decreasing_list(1, _percentage, acc), do: Enum.reverse([1 | acc])

  defp generate_decreasing_list(number, percentage, acc) do
    new_number = trunc(number - number * percentage / 100.0)
    generate_decreasing_list(new_number, percentage, [number | acc])
  end
end

results = [best_case: EntityResolution.run("/app/produtos.txt", 1000)]

:entity_resolution |> Application.fetch_env!(:algorithm) |> GenServer.stop()

results =
  Enum.reduce(
    [{:median_case_1, 5_000, 10.0}, {:median_case_2, 10_000, 10.0}, {:worst_case, 10_000, 50.0}],
    results,
    fn {case_name, block, percentage}, acc ->
      result =
        block
        |> DecreasingList.generate_decreasing_list(percentage)
        |> Enum.drop(-1)
        |> then(fn list ->
          result = EntityResolution.run("/app/produtos.txt", list)
          :entity_resolution |> Application.fetch_env!(:algorithm) |> GenServer.stop()
          result
        end)

      acc ++ [{case_name, result}]
    end
  )
