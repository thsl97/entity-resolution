defmodule EntityResolutionWorker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config())
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EntityResolutionWorker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp poolboy_config do
    [
      name: {:local, :worker},
      worker_module: EntityResolutionWorker,
      size:
        :entity_resolution
        |> Application.fetch_env!(:workers)
        |> Enum.find(fn {worker, _} -> worker == Node.self() end)
        |> elem(1),
      max_overflow: 0
    ]
  end
end
