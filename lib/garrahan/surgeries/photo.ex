defmodule Garrahan.Surgeries.Photo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Garrahan.Surgeries.Surgery

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "photos" do
    field :filename, :string
    belongs_to(:surgery, Surgery)

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:filename, :surgery_id])
    |> validate_required([:filename, :surgery_id])
  end
end
