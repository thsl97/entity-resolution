defmodule EntityResolution.Algorithms.WeightedRoundRobin do
  use EntityResolution.Algorithms.BaseServer

  @impl true
  def init(servers) do
    servers = Enum.map(servers, &Map.put(&1, :current_weight, 1))
    {:ok, servers}
  end

  @impl true
  def handle_call(:get_next_server, _from, [
        %{name: current_server, weight: weight, current_weight: weight} = server | servers
      ]) do
    {:reply, current_server, servers ++ [Map.put(server, :current_weight, 1)]}
  end

  def handle_call(:get_next_server, _from, [
        %{name: current_server, current_weight: weight} = server | servers
      ]) do
    {:reply, current_server, [Map.put(server, :current_weight, weight + 1)] ++ servers}
  end
end
