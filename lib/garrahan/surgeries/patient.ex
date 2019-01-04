defmodule Garrahan.Surgeries.Patient do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "patients" do
    field :address, :string
    field :birthdate, :date
    field :city, :string
    field :first_name, :string
    field :last_name, :string
    field :province, :string

    timestamps()
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [:first_name, :last_name, :birthdate, :city, :province, :address])
    |> validate_required([:first_name, :last_name, :birthdate, :city, :province, :address])
  end
end
