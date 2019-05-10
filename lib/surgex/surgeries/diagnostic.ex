defmodule Surgex.Surgeries.Diagnostic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Surgex.Surgeries.Surgery

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "diagnostics" do
    field :name, :string
    field :description, :string
    has_many :surgery, Surgery

    timestamps()
  end

  @doc false
  def changeset(diagnostic, attrs) do
    diagnostic
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
