defmodule Garrahan.Surgeries.Diagnostic do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "diagnostics" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(diagnostic, attrs) do
    diagnostic
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
