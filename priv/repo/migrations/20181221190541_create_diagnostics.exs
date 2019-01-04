defmodule Garrahan.Repo.Migrations.CreateDiagnostics do
  use Ecto.Migration

  def change do
    create table(:diagnostics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text

      timestamps()
    end
  end
end
