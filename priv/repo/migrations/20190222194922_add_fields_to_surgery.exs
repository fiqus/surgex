defmodule Surgex.Repo.Migrations.AddFieldsToSurgery do
  use Ecto.Migration

  def change do
    alter table("surgeries") do
      add :diagnostic_id, references(:diagnostics, on_delete: :nothing, type: :binary_id)
      add :comments, :text
    end

    create index(:surgeries, [:diagnostic_id])
  end
end
