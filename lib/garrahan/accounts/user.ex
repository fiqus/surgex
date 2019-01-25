defmodule Garrahan.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :password_hash, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean, default: false
    field :disabled, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, %{"password" => _} = attrs) when map_size(attrs) == 1 do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :is_admin, :disabled])
    |> validate_required([:password])
    |> validate_password()
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 6, max: 30)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        changeset
        |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
