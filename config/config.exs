# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config
import_config "scout_apm.exs"

# General application configuration
config :montacargas,
  ecto_repos: [MontaCargas.Repo],
  loggers: [{Ecto.LogEntry, :log, []},
            {ScoutApm.Instruments.EctoLogger, :log, []}]

# Configures the endpoint
config :montacargas, MontaCargasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eDCYEECZcmluqcvZ2mQ6mw94W0d0MXhy4WOgAEepLBmauugUpaphJ7osZp+Tb/+S",
  render_errors: [view: MontaCargasWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MontaCargas.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :montacargas, MontaCargasWeb.Guardian,
  issuer: "monta-cargas",
  ttl: {30, :days},
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")
