# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Garrahan.Repo.insert!(%Garrahan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Garrahan.Accounts

# Users
Accounts.create_user(%{
  email: "info+admin@fiqus.com",
  name: "Fiqus Admin",
  password: "adminpass",
  is_admin: true
})

Accounts.create_user(%{
  email: "info+user@fiqus.com",
  name: "Fiqus User",
  password: "userpass"
})
