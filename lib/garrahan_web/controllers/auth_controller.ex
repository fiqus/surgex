defmodule GarrahanWeb.AuthController do
  use GarrahanWeb, :controller

  def token(conn, %{"email" => email, "password" => password}) do
    with {:ok, surgeon} <- Garrahan.Auth.authenticate_user(email, password),
         {:ok, token} <- Garrahan.Auth.token(surgeon.user) do
      render(conn, "token.json", token: token, surgeon: surgeon)
    else
      {:error, reason} ->
        conn
        |> put_status(:forbidden)
        |> render("error.json", error: reason)
    end
  end

  def is_auth(conn, %{"token" => token}) do
    render(conn, "auth.json", auth: Garrahan.Auth.is_auth?(token))
  end

  def is_auth(conn, _) do
    render(conn, "auth.json", auth: false)
  end
end
