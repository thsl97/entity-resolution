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

results =
  Enum.map([{5_000, 10.0}, {10_000, 10.0}, {10_000, 50.0}], fn {block, percentage} ->
    block
    |> DecreasingList.generate_decreasing_list(percentage)
    |> Enum.drop(-1)
    |> then(fn list ->
      result = EntityResolution.run("/app/produtos.txt", list)
      :entity_resolution |> Application.fetch_env!(:algorithm) |> GenServer.stop()
      result
    end)
  end)
