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
alias Garrahan.Surgeries

# Users
{:ok, admin} =
  Accounts.create_user(%{
    password: "adminpass",
    is_admin: true
  })

{:ok, user} =
  Accounts.create_user(%{
    password: "userpass"
  })

# Surgeons
Surgeries.create_surgeon(%{
  user_id: admin.id,
  email: "info+admin@fiqus.com",
  first_name: "Fiqus",
  last_name: "Admin"
})

Surgeries.create_surgeon(%{
  user_id: user.id,
  email: "info+user@fiqus.com",
  first_name: "Fiqus",
  last_name: "User"
})

# Patients
Surgeries.create_patient(%{
  medical_history: "1234",
  first_name: "someFirt1",
  last_name: "someLast1",
  birthdate: nil,
  city: "someCity",
  province: "someProvince",
  address: "someAddres"
})

Surgeries.create_patient(%{
  medical_history: "4321",
  first_name: "someFirt2",
  last_name: "someLast12",
  birthdate: nil,
  city: "someCity",
  province: "someProvince",
  address: "someAddres"
})
