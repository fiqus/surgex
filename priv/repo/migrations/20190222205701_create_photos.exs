defmodule Garrahan.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :filename, :string
      add :surgery_id, references(:surgeries, type: :binary_id)

      timestamps()
    end

    create index(:photos, [:surgery_id])
  end
end
