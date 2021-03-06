defmodule Surgex.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :password_hash, :string
      add :is_admin, :boolean, default: false
      add :disabled, :boolean, default: false

      timestamps()
    end
  end
end
