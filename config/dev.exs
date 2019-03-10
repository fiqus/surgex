use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :garrahan, GarrahanWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :garrahan, GarrahanWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/garrahan_web/views/.*(ex)$},
      ~r{lib/garrahan_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure your database
config :garrahan, Garrahan.Repo,
  username: "postgres",
  password: "postgres",
  database: "garrahan",
  hostname: "localhost",
  pool_size: 10

# Configure Guardian
config :garrahan, Garrahan.Auth.Guardian,
  issuer: "garrahan",
  verify_issuer: true,
  ttl: {12, :hours},
  secret_key: "iox6/puy13hvGIa76aY1XQR8nDx3DUzjYnKz14geFGk5w0ZktbQwVsfw9E++ERaL"

config :garrahan,
  user_verification_salt: "V08JhpdqE61mbsC8M/Z9uZguGl+Uku72BrbYvjZSOlzaNNjcQROqetH4RTQn1YCo",
  user_recover_salt: "cio8UrnqYvIjTQQ8Mwiyx+Quuk+DXbqnoZZjdAbbrTWGOgPJtaGLleslpf2/X10h4"

# Configures bamboo mailer
config :garrahan, Garrahan.Mailer,
  adapter: Bamboo.LocalAdapter,
  # optional
  open_email_in_browser_url: "http://localhost:4000/sent_emails"
