defmodule Garrahan.Surgeries.Surgery do
  use Ecto.Schema
  import Ecto.Changeset
  alias Garrahan.Surgeries.Patient
  alias Garrahan.Surgeries.Surgeon

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "surgeries" do
    field :date, :date
    belongs_to(:patient, Patient)
    # field :patient_id, :binary_id
    belongs_to(:surgeon, Surgeon)
    # field :surgeon_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(surgery, attrs) do
    surgery
    |> cast(attrs, [:date])
    |> validate_required([:date])
  end
end
