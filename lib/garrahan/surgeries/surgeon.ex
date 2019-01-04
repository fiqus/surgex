defmodule Garrahan.Surgeries.Surgeon do
  use Ecto.Schema
  import Ecto.Changeset
  alias Garrahan.Surgeries.Surgery

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "surgeons" do
    field :first_name, :string
    field :last_name, :string
    field :license, :string
    has_many(:surgery, Surgery)

    timestamps()
  end

  @doc false
  def changeset(surgeon, attrs) do
    surgeon
    |> cast(attrs, [:first_name, :last_name, :license])
    |> validate_required([:first_name, :last_name, :license])
    |> unique_constraint(:license)
  end
end
