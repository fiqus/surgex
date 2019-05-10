defmodule Surgex.Repo do
  use Ecto.Repo,
    otp_app: :surgex,
    adapter: Ecto.Adapters.Postgres
end
