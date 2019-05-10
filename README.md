# Surgex
🇦🇷 Aplicación Web de código abierto realizada como donación de 💓 desde [Fiqus](https://fiqus.coop) al servicio de Cirugía Plástica del [Hospital de Pediatría Garrahan](http://www.garrahan.gov.ar/).

🇬🇧 This is an open sourced web application done as a donation with 💓 from [Fiqus](https://fiqus.coop) to the plastic surgery service of the [Hospital de Pediatría Garrahan](http://www.garrahan.gov.ar/).


# Development
## Pre-requisites:
You will have to install:
  * `Elixir` 1.5 or later
  * `Erlang` 1.8 or later
  * `Node.js` 5 or later
  * `PostgreSQL`

## ENV Vars
  * `PORT` - the port for the web application
  * `SMTP_USERNAME` - for the mailer
  * `SMTP_PASSWORD` - for the mailer
  * `GUARDIAN_SECRET_KEY` - for token generation
  * `USER_VERIFICATION_SALT` - for user token in the activation email
  * `USER_RECOVER_SALT` - for user token in the recover email

## Start the server

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Test
  * `mix test` - run the tests
  * `mix coverage` - for test coverage