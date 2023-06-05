defmodule EntityResolution.Algorithms.WeightedRoundRobin do
  use EntityResolution.Algorithms.BaseServer

  @impl true
  def init(servers) do
    servers |> Enum.map(&Map.put(&1, :current_weight, 1)) |> then(&{:ok, {&1, 0}})
  end

  @impl true
  def handle_call(:get_next_server, from, {servers, current_server_index})
      when length(servers) == current_server_index,
      do: handle_call(:get_next_server, from, {servers, 0})

  def handle_call(:get_next_server, _from, {servers, current_server_index}) do
    %{server: server_name} = current_server = Enum.at(servers, current_server_index)

    new_state =
      current_server
      |> handle_weight(current_server_index)
      |> then(fn {server, index} ->
        {List.replace_at(servers, current_server_index, server), index}
      end)

    {:reply, server_name, new_state}
  end

  defp handle_weight(%{current_weight: weight, weight: weight} = server, index) do
    {Map.put(server, :current_weight, 1), index + 1}
  end

  defp handle_weight(%{current_weight: current_weight} = server, index) do
    {Map.put(server, :current_weight, current_weight + 1), index}
  end
end
