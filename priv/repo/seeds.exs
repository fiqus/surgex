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
  social_id: "11111111",
  medical_history: "A11111111",
  first_name: "Pablo",
  last_name: "Ferrabrud",
  email: "pferrabrud@fiqus.com",
  birthdate: nil,
  city: "C.A.B.A.",
  province: "Bs. As.",
  address: "Lambireaux 482"
})

Surgeries.create_patient(%{
  social_id: "22222222",
  medical_history: "A22222222",
  first_name: "Diego",
  last_name: "Mansillero",
  email: "dmansillero@fiqus.com",
  birthdate: nil,
  city: "Villa La Angostura",
  province: "Neuquén",
  address: "Gigesilva 1375"
})
