# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :capsens_qonto,
  ecto_repos: [CapsensQonto.Repo]

# Configures the endpoint
config :capsens_qonto, CapsensQontoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PIotlyTAvJ8dXPiPcxBAn08tIKMyL+ek1WMMkUqWRjChtiveiLK+srhT3qcU0I34",
  render_errors: [view: CapsensQontoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CapsensQonto.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "AcfDmcnx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :capsens_qonto, CapsensQontoWeb.Gettext, locales: ~w(fr en), default_locale: "fr"

config :capsens_qonto, CapsensQontoWeb.Guardian,
  issuer: "capsens_qonto",
  secret_key: "m3B565qpZ4lE4nrKsylFM4KgJb9UnQjSnySE+NdSkeBGtJxUIIX/UzkOJP1OV0zS"

config :capsens_qonto, CapsensQonto.Scheduler,
  jobs: [
    {"*/5 * * * *", {CapsensQonto.Transactions, :send_report, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
