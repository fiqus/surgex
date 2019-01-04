defmodule Garrahan.Repo.Migrations.CreateSurgeries do
  use Ecto.Migration

  def change do
    create table(:surgeries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :medical_history, :string
      add :date, :date
      add :patient_id, references(:patients, on_delete: :nothing, type: :binary_id)
      add :surgeon_id, references(:surgeons, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:surgeries, [:patient_id])
    create index(:surgeries, [:surgeon_id])
  end
end
