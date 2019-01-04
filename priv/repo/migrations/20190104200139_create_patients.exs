defmodule Garrahan.Repo.Migrations.CreatePatients do
  use Ecto.Migration

  def change do
    create table(:patients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :birthdate, :date
      add :city, :string
      add :province, :string
      add :address, :string

      timestamps()
    end
  end
end
