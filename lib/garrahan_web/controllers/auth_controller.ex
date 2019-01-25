defmodule GarrahanWeb.AuthController do
  use GarrahanWeb, :controller

  def token(conn, %{"email" => email, "password" => password}) do
    with {:ok, surgeon} <- Garrahan.Auth.authenticate_user(email, password),
         {:ok, token} <- Garrahan.Auth.token(surgeon.user) do
      render(conn, "token.json", token: token, surgeon: surgeon)
    else
      {:error, reason} ->
        render(conn, "error.json", error: reason)
    end
  end
end
