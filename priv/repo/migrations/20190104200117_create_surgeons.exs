defmodule Garrahan.Repo.Migrations.CreateSurgeons do
  use Ecto.Migration

  def change do
    create table(:surgeons, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :license, :string

      timestamps()
    end

    create unique_index(:surgeons, [:license])
  end
end
