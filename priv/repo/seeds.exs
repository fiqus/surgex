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
{:ok, surgeon1} =
  Surgeries.create_surgeon(%{
    user_id: admin.id,
    email: "info+admin@fiqus.com",
    first_name: "Fiqus",
    last_name: "Admin"
  })

{:ok, surgeon2} =
  Surgeries.create_surgeon(%{
    user_id: user.id,
    email: "info+user@fiqus.com",
    first_name: "Fiqus",
    last_name: "User"
  })

# Patients
{:ok, patient1} =
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

{:ok, patient2} =
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

{:ok, diagnostic1} =
  Surgeries.create_diagnostic(%{
    name: "Paladar hendido",
    description: "Una descripción para paladar hendido"
  })

{:ok, diagnostic2} =
  Surgeries.create_diagnostic(%{
    name: "Otros",
    description: "Todavía no hay un diagnóstico específico."
  })

# Surgeries
Surgeries.create_surgery(%{
  surgeon_id: surgeon1.id,
  patient_id: patient1.id,
  diagnostic_id: diagnostic1.id,
  date: ~D[2010-04-17]
})

Surgeries.create_surgery(%{
  surgeon_id: surgeon1.id,
  patient_id: patient2.id,
  diagnostic_id: diagnostic1.id,
  date: ~D[2012-05-21]
})

Surgeries.create_surgery(%{
  surgeon_id: surgeon2.id,
  patient_id: patient2.id,
  diagnostic_id: diagnostic2.id,
  date: ~D[2022-11-27]
})
