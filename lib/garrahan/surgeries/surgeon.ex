defmodule Garrahan.Surgeries.Surgeon do
  use Ecto.Schema
  import Ecto.Changeset
  alias Garrahan.Surgeries.Surgery
  alias Garrahan.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "surgeons" do
    field :social_id, :string
    field :license, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :birthdate, :date
    field :nationality, :string
    field :address, :string
    field :city, :string
    field :province, :string
    belongs_to(:user, User)
    has_many(:surgeries, Surgery)

    many_to_many(
      :assistants,
      Surgery,
      join_through: "surgeries_surgeons"
    )

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
    |> cast(attrs, [
      :user_id,
      :social_id,
      :license,
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
    |> validate_required([:email, :first_name, :last_name])
    |> unique_constraint(:social_id)
    |> unique_constraint(:license)
    |> unique_constraint(:email)
  end
end
