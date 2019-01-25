defmodule Garrahan.Surgeries.Patient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Garrahan.Surgeries.Surgery

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "patients" do
    field :medical_history, :string
    field :first_name, :string
    field :last_name, :string
    field :birthdate, :date
    field :city, :string
    field :province, :string
    field :address, :string
    has_many(:surgery, Surgery)

    timestamps()
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [
      :medical_history,
      :first_name,
      :last_name,
      :birthdate,
      :city,
      :province,
      :address
    ])
    |> validate_required([:first_name, :last_name])
  end
end
