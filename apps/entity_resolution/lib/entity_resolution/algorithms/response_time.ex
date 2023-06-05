defmodule EntityResolution.Algorithms.ResponseTime do
  use EntityResolution.Algorithms.BaseServer

  def update_response_time(server_name, response_time) do
    GenServer.cast(__MODULE__, {:update_response_time, server_name, response_time})
  end

  @impl true
  def init(servers) do
    servers |> Enum.map(&Map.put(&1, :response_time, 0)) |> then(&{:ok, &1})
  end

  @impl true
  def handle_call(:get_next_server, _from, servers) do
    %{name: server_name} =
      Enum.min_by(servers, fn %{response_time: response_time} -> response_time end)

    {:reply, server_name, servers}
  end

  @impl true
  def handle_cast({:update_response_time, server_name, new_response_time}, servers) do
    {%{response_time: response_time} = server, index} =
      servers
      |> Enum.with_index()
      |> Enum.find(fn {%{name: name}, _} -> name == server_name end)

    new_state =
      server
      |> Map.put(:response_time, (response_time + new_response_time) / 2)
      |> then(&List.replace_at(servers, index, &1))

    {:noreply, new_state}
  end
end
