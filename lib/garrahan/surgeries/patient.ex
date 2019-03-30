defmodule Garrahan.Surgeries.Patient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Garrahan.Surgeries.Surgery

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "patients" do
    field :social_id, :string
    field :medical_history, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :birthdate, :date
    field :nationality, :string
    field :address, :string
    field :city, :string
    field :province, :string
    has_many(:surgery, Surgery)

    timestamps()
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [
      :social_id,
      :medical_history,
      :first_name,
      :last_name,
      :email,
      :phone,
      :birthdate,
      :nationality,
      :address,
      :city,
      :province
    ])
    |> validate_required([:first_name, :last_name])
    |> unique_constraint(:social_id)
    |> unique_constraint(:medical_history)
    |> unique_constraint(:email)
  end
end
