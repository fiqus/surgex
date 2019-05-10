defmodule Surgex.Repo.Migrations.CreateSurgeons do
  use Ecto.Migration

  def change do
    create table(:surgeons, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :license, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:surgeons, [:user_id])
    create unique_index(:surgeons, [:email])
    create unique_index(:surgeons, [:license])
  end
end
