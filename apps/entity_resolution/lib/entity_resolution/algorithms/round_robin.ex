defmodule EntityResolution.Algorithms.RoundRobin do
  use EntityResolution.Algorithms.BaseServer

  @impl true
  def init(servers) do
    {:ok, servers}
  end

  @impl true
  def handle_call(:get_next_server, _from, [%{name: current_server} = server | servers]) do
    {:reply, current_server, servers ++ [server]}
  end
end
