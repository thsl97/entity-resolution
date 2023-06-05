defmodule EntityResolution.Worker do
  def resolve_entities(chunk) do
    Enum.reduce(chunk, [], fn elem, acc ->
      if any_duplicates?(elem, acc) do
        acc
      else
        [elem] ++ acc
      end
    end)
  end

  defp any_duplicates?(elem, list) do
    Enum.any?(list, fn list_elem -> String.jaro_distance(elem, list_elem) >= 0.7 end)
  end
end
