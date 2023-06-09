defmodule EntityResolutionWorker do
  use GenServer

  def resolve_entities(chunk) do
    Task.async(fn ->
      :poolboy.transaction(
        :worker,
        fn pid ->
          GenServer.call(pid, {:resolve_entities, chunk}, :infinity)
        end,
        :infinity
      )
    end)
    |> Task.await(:infinity)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:resolve_entities, chunk}, _from, state) do
    start = System.monotonic_time(:millisecond)

    result =
      Enum.reduce(chunk, [], fn elem, acc ->
        if any_duplicates?(elem, acc) do
          acc
        else
          [elem] ++ acc
        end
      end)

    {:reply, {result, System.monotonic_time(:millisecond) - start}, state}
  end

  defp any_duplicates?(elem, list) do
    Enum.any?(list, fn list_elem -> String.jaro_distance(elem, list_elem) >= 0.7 end)
  end
end
