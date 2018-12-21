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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
