defmodule Garrahan.Repo.Migrations.CreateSurgerySurgeon do
  use Ecto.Migration

  def change do
    create table(:surgeries_surgeons, primary_key: false) do
      add :surgery_id, references(:surgeries, type: :binary_id)
      add :surgeon_id, references(:surgeons, type: :binary_id)
      end

      create unique_index(:surgeries_surgeons, [:surgery_id, :surgeon_id])
  end
end
