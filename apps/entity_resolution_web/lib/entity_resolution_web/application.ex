defmodule EntityResolutionWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias EntityResolution.Algorithms.LeastConnections
  alias EntityResolution.Algorithms.ResponseTime
  alias EntityResolution.Algorithms.RoundRobin
  alias EntityResolution.Algorithms.WeightedLeastConnections
  alias EntityResolution.Algorithms.WeightedRoundRobin

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EntityResolutionWeb.Telemetry,
      # Start the Endpoint (http/https)
      EntityResolutionWeb.Endpoint,
      # Start a worker by calling: EntityResolutionWeb.Worker.start_link(arg)
      # {EntityResolutionWeb.Worker, arg}
      {LeastConnections, []},
      {ResponseTime, []},
      {RoundRobin, []},
      {WeightedLeastConnections, []},
      {WeightedRoundRobin, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EntityResolutionWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EntityResolutionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
