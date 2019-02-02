use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :garrahan, GarrahanWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :garrahan, Garrahan.Repo,
  username: "postgres",
  password: "postgres",
  database: "garrahan_test",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Guardian
config :garrahan, Garrahan.Auth.Guardian,
  issuer: "garrahan",
  secret_key: "UDR8nL8PI/JN+fJioxlErRSa82h8nyL4SzhA/N8Wc5ox+KrGgUZdZZI0gSMN+TPQ"
