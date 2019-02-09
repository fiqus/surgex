# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :garrahan,
  ecto_repos: [Garrahan.Repo]

# Configures the endpoint
config :garrahan, GarrahanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2M/NGvn2rebhLSI80LQp0YVdyB5SUakOCOZGEbrR5fkc6Ju6Uj8hl9LnDPcaTqxX",
  render_errors: [view: GarrahanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Garrahan.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :garrahan, :generators,
  migration: true,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

# Configures bamboo mailer
config :garrahan, Garrahan.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  hostname: "smtp.gmail.com",
  port: 465,
  username: {:system, "SMTP_USERNAME"},
  password: {:system, "SMTP_PASSWORD"},
  # can be `:always` or `:never`
  tls: :if_available,
  # or {":system", ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: true,
  retries: 1,
  no_mx_lookups: false,
  # can be `always`. If your smtp relay requires authentication set it to `always`.
  auth: :if_available

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
