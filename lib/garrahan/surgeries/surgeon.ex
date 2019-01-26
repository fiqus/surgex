defmodule Garrahan.Surgeries.Surgeon do
  use Ecto.Schema
  import Ecto.Changeset
  alias Garrahan.Surgeries.Surgery
  alias Garrahan.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "surgeons" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :license, :string
    # field :user_id, :binary_id
    belongs_to(:user, User)
    has_many(:surgeries, Surgery)

    timestamps()
  end

  @doc """
  Ensure to set user_id field when a %User{} is given in attrs
  """
  def changeset(surgeon, %{user: %User{}} = attrs) do
    changeset(surgeon, attrs |> Map.delete(:user) |> Map.put(:user_id, attrs.user.id))
  end

  @doc false
  def changeset(surgeon, attrs) do
    surgeon
    |> cast(attrs, [:user_id, :email, :first_name, :last_name, :license])
    |> validate_required([:email, :first_name, :last_name])
    |> unique_constraint(:email)
    |> unique_constraint(:license)
  end
end
