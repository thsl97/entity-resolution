defmodule DecreasingList do
  def generate_decreasing_list(number, percentage) when number > 0 and percentage >= 0.0 and percentage <= 100.0 do
    generate_decreasing_list(number, percentage, [])
  end

  defp generate_decreasing_list(1, _percentage, acc), do: Enum.reverse([1 | acc])
  defp generate_decreasing_list(number, percentage, acc) do
    new_number = trunc(number - (number * percentage / 100.0))
    generate_decreasing_list(new_number, percentage, [number | acc])
  end
end
