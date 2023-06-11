defmodule EntityResolution.Algorithms.ResponseTime do
  use EntityResolution.Algorithms.BaseServer

  def update_response_time(server_name, response_time) do
    GenServer.cast(__MODULE__, {:update_response_time, server_name, response_time})
  end

  @impl true
  def init(servers) do
    servers
    |> Enum.map(&Map.merge(&1, %{active_connections: 0, response_time: 0}))
    |> then(&{:ok, &1})
  end

  @impl true
  def handle_call(:get_next_server, _from, servers) do
    %{active_connections: active_connections_to_filter} =
      Enum.min_by(servers, & &1.active_connections)

    {%{name: server_name} = server, index} =
      servers
      |> Enum.with_index()
      |> Enum.filter(fn {%{active_connections: active_connections}, _} ->
        active_connections == active_connections_to_filter
      end)
      |> Enum.min_by(fn {%{response_time: response_time}, _} -> response_time end)

    new_state =
      server
      |> Map.update!(:active_connections, &(&1 + 1))
      |> then(&List.replace_at(servers, index, &1))

    {:reply, server_name, new_state}
  end

  @impl true
  def handle_cast({:update_response_time, server_name, new_response_time}, servers) do
    {server, index} =
      servers
      |> Enum.with_index()
      |> Enum.find(fn {%{name: name}, _} -> name == server_name end)

    new_state =
      server
      |> Map.update!(:response_time, &((&1 + new_response_time) / 2))
      |> Map.update!(:active_connections, &(&1 - 1))
      |> then(&List.replace_at(servers, index, &1))

    {:noreply, new_state}
  end
end
