defmodule Garrahan.Auth do
  require Logger

  alias Garrahan.Accounts
  alias Garrahan.Accounts.User

  def authenticate_user(email, given_password) do
    Accounts.get_user_by_email(email)
    |> validate_user(given_password)
  end

  defp validate_user(nil, _), do: {:error, "EMAIL_NOT_EXISTS"}

  defp validate_user(user, given_password) do
    with :ok <- check_user_disabled(user),
         :ok <- verify_password_hash(given_password, user) do
      {:ok, user}
    else
      # {:error, "WRONG_PASSWORD"} ->
      #   Accounts.save_user_failed_login(user, given_password)
      #   {:error, "WRONG_PASSWORD"}

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

  def login(conn, user) do
    with {:ok, conn} <- sign_in_user(conn, user) do
      {:ok, conn}
    else
      error ->
        Logger.error("Error on login: #{inspect(error)}")
        {:error, error}
    end
  end

  defp sign_in_user(conn, %User{is_admin: true} = user) do
    {:ok, Garrahan.Auth.Guardian.Plug.sign_in(conn, user, %{admin: true})}
  end

  defp sign_in_user(conn, user) do
    {:ok, Garrahan.Auth.Guardian.Plug.sign_in(conn, user, %{admin: false})}
  end

  def logout(conn) do
    {:ok, Garrahan.Auth.Guardian.Plug.sign_out(conn)}
  end
end
