defmodule EntityResolution.Algorithms.RoundRobin do
  use EntityResolution.Algorithms.BaseServer

  @impl true
  def init(servers) do
    {:ok, {servers, 0}}
  end

  @impl true
  def handle_call(:get_next_server, _from, {[%{name: current_server} | _] = servers, 0}) do
    {:reply, current_server, {servers, 1}}
  end

  def handle_call(:get_next_server, _from, {servers, current_server_index})
      when length(servers) == current_server_index + 1 do
    {:reply, servers |> List.last(servers) |> Map.fetch!(:name), {servers, 0}}
  end

  def handle_call(:get_next_server, _from, {servers, current_server_index}) do
    current_server = servers |> Enum.at(current_server_index) |> Map.fetch!(:name)
    next_server_index = current_server_index + 1
    {:reply, current_server, {servers, next_server_index}}
  end
end
