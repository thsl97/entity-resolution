defmodule EntityResolution.Algorithms.LeastConnections do
  use EntityResolution.Algorithms.BaseServer

  def free_connection(server_name) do
    GenServer.cast(__MODULE__, {:free_connection, server_name})
  end

  @impl true
  def init(servers) do
    servers |> Enum.map(&Map.put(&1, :connections, 0)) |> then(&{:ok, &1})
  end

  @impl true
  def handle_call(:get_next_server, _from, servers) do
    {%{name: server_name, connections: connections} = server, index} =
      servers
      |> Enum.with_index()
      |> Enum.min_by(fn {%{connections: connections}, _} -> connections end)

    new_state =
      server
      |> Map.put(:connections, connections + 1)
      |> then(&List.replace_at(servers, index, &1))

    {:reply, server_name, new_state}
  end

  @impl true
  def handle_cast({:free_connection, server_name}, servers) do
    {%{connections: connections} = server, index} =
      servers
      |> Enum.with_index()
      |> Enum.find(fn {%{name: name}, _} -> name == server_name end)

    new_state =
      server
      |> Map.put(:connections, connections - 1)
      |> then(&List.replace_at(servers, index, &1))

    {:noreply, new_state}
  end
end
