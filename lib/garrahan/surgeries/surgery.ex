defmodule Garrahan.Surgeries.Surgery do
  use Ecto.Schema
  import Ecto.Changeset
  alias Garrahan.Surgeries.{Patient, Surgeon, Diagnostic}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "surgeries" do
    field :date, :date
    belongs_to(:patient, Patient)
    belongs_to(:surgeon, Surgeon)
    belongs_to(:diagnostic, Diagnostic)

    timestamps()
  end

  @doc false
  def changeset(surgery, attrs) do
    surgery
    |> cast(attrs, [:date, :surgeon_id, :diagnostic_id, :patient_id])
    |> validate_required([:date, :surgeon_id, :patient_id])
  end
end
