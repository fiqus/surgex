defmodule GarrahanWeb.AuthController do
  use GarrahanWeb, :controller

  def token(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Garrahan.Auth.authenticate_user(email, password),
         {:ok, token} <- Garrahan.Auth.token(user) do
      render(conn, "token.json", token: token)
    else
      {:error, reason} ->
        render(conn, "error.json", error: reason)
    end
  end
end
