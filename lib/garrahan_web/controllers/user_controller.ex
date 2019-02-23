defmodule GarrahanWeb.UserController do
  use GarrahanWeb, :controller

  alias Garrahan.Accounts
  alias Garrahan.Accounts.{ActivationToken, User}

  action_fallback GarrahanWeb.FallbackController
  # Requires to be an admin!
  plug(Garrahan.Auth.Plug.AdminUser, [] when action not in [:activate])

  def index(conn, _params) do
    users =
      Accounts.list_users()
      |> Accounts.attach_surgeon_data()

    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user =
      Accounts.get_user!(id)
      |> Accounts.attach_surgeon_data()

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: Accounts.attach_surgeon_data(user))
    end
  end

  def activate(conn, %{"token" => token}) do
    with {:ok, user_id} <- ActivationToken.verify(token),
         %User{password_hash: nil} = user <- Accounts.get_user!(user_id) do
        render(conn, "show.json", user: Accounts.attach_surgeon_data(user))
    else
      %User{password_hash: password_hash} when is_binary(password_hash) ->
        render_error(conn, "ALREADY_ACTIVATED")
      _ ->
        render_error(conn, "WRONG_TOKEN")
    end
  end

  # @TODO WIP [DMC] #13: Pantalla de activación de usuario.
  def activate(conn, %{"token" => token, "password" => _password, "confirm" => _confirm}) do
    with {:ok, user_id} <- ActivationToken.verify(token),
         %User{password_hash: nil} = user <- Accounts.get_user!(user_id) do
        #changeset = Accounts.change_user(user)
        render(conn, "show.json", user: Accounts.attach_surgeon_data(user))
    else
      %User{password_hash: password_hash} when is_binary(password_hash) ->
        render_error(conn, "ALREADY_ACTIVATED")
      _ ->
        render_error(conn, "WRONG_TOKEN")
    end
  end

  def activate(conn, _) do
    render_error(conn, "WRONG_TOKEN")
  end

  defp render_error(conn, error) do
    conn
      |> put_status(:bad_request)
      |> render("error.json", error: error)
  end
end
