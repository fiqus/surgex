defmodule Surgex.Surgeries.Photo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Surgex.Surgeries.Surgery

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "photos" do
    field :filename, :string
    field :md5, :string
    belongs_to(:surgery, Surgery)

    timestamps()
  end

  @doc false
  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:filename, :md5, :surgery_id])
    |> validate_required([:filename, :md5, :surgery_id])
    |> unique_constraint(:md5)
  end
end
