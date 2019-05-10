use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :surgex, SurgexWeb.Endpoint,
  load_from_system_env: true,
  server: true,
  secret_key_base: "${SECRET_KEY_BASE}",
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [host: "${APP_NAME}.gigalixirapp.com", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Configure Guardian
config :surgex, Surgex.Auth.Guardian,
  issuer: "surgex",
  verify_issuer: true,
  ttl: {24, :hours},
  secret_key: {:system, "GUARDIAN_SECRET_KEY"}

config :surgex,
  user_verification_salt: {:system, "USER_VERIFICATION_SALT"},
  user_recover_salt: {:system, "USER_RECOVER_SALT"}

config :surgex, Surgex.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "${DATABASE_URL}",
  database: "",
  ssl: true,
  pool_size: 2
