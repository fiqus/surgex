defmodule Garrahan.Auth do
  require Logger

  alias Garrahan.Accounts.User
  alias Garrahan.Surgeries

  def authenticate_user(email, given_password) do
    Surgeries.get_surgeon_by_email(email)
    |> validate_user(given_password)
  end

  defp validate_user(nil, _), do: {:error, "EMAIL_NOT_EXISTS"}

  defp validate_user(surgeon, given_password) do
    user = surgeon.user

    with :ok <- check_user_disabled(user),
         :ok <- verify_password_hash(given_password, user) do
      {:ok, surgeon}
    else
      error ->
        error
    end
  end

  defp check_user_disabled(%User{disabled: true}), do: {:error, "USER_DISABLED"}
  defp check_user_disabled(_), do: :ok

  defp verify_password_hash(given_password, user) do
    case Bcrypt.verify_pass(given_password, user.password_hash) do
      true -> :ok
      false -> {:error, "WRONG_PASSWORD"}
    end
  end

  def token(user) do
    with {:ok, token, _claims} <- encode_and_sign(user, %{}) do
      {:ok, token}
    else
      error ->
        Logger.error("Error on token: #{inspect(error)}")
        {:error, error}
    end
  end

  defp encode_and_sign(user, claims) do
    Garrahan.Auth.Guardian.encode_and_sign(user, claims)
  end

  def is_auth?(token) do
    case Garrahan.Auth.Guardian.decode_and_verify(token) do
      {:ok, _} ->
        true

      _ ->
        false
    end
  end
end
