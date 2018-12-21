defmodule Garrahan.Repo do
  use Ecto.Repo,
    otp_app: :garrahan,
    adapter: Ecto.Adapters.Postgres
end
