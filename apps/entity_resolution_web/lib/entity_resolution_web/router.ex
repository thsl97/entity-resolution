defmodule EntityResolutionWeb.Router do
  use EntityResolutionWeb, :router
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:fetch_session, :protect_from_forgery]

    live_dashboard "/dashboard", metrics: EntityResolutionWeb.Telemetry
  end
end
