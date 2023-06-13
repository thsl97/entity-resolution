# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :entity_resolution_web,
  generators: [context_app: :entity_resolution]

# Configures the endpoint
config :entity_resolution_web, EntityResolutionWeb.Endpoint,
  check_origin: false,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: EntityResolutionWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: EntityResolution.PubSub,
  live_view: [signing_salt: "WJ+x//mE"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/entity_resolution_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/entity_resolution_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :entity_resolution,
  workers: %{
    :"worker@worker-1" => 4,
    :"worker@worker-2" => 3,
    :"worker@worker-3" => 2
  },
  algorithm: EntityResolution.Algorithms.ResponseTime,
  env: config_env()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
