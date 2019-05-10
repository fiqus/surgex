defmodule Surgex.Repo.Migrations.AddFieldsToPatientsAndSurgeons do
  use Ecto.Migration

  def change do
    alter table("patients") do
      add :email, :string
      add :phone, :string
      add :social_id, :string
      add :nationality, :string
    end

    create unique_index(:patients, [:email])
    create unique_index(:patients, [:social_id])

    alter table("surgeons") do
      add :phone, :string
      add :birthdate, :date
      add :social_id, :string
      add :nationality, :string
      add :address, :string
      add :city, :string
      add :province, :string
    end

    create unique_index(:surgeons, [:social_id])
  end
end
