defmodule GarrahanWeb.AuthController do
  use GarrahanWeb, :controller

  def login(conn, %{"session" => %{"email" => email, "password" => password}}) do
    with {:ok, user} <- Garrahan.Auth.authenticate_user(email, password),
         {:ok, token} <- Garrahan.Auth.login(conn, user) do
      render(conn, "show.json", token: token)
    else
      {:error, reason} ->
        render(conn, "error.json", error: reason)
    end
  end

  def logout(conn, _) do
    {:ok, conn} = Garrahan.Auth.logout(conn)
    render(conn, "show.json", status: :ok)
  end
end
