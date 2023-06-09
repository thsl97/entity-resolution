defmodule EntityResolution.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {algorithm(), []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: LoadBalancer.Supervisor)
  end

  defp algorithm do
    Application.fetch_env!(:entity_resolution, :algorithm)
  end
end
