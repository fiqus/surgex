defmodule GarrahanWeb.UserController do
  use GarrahanWeb, :controller

  alias Garrahan.Accounts
  alias Garrahan.Accounts.{ActivationToken, User}

  action_fallback GarrahanWeb.FallbackController
  # Requires to be an admin!
  plug Garrahan.Auth.Plug.AdminUser, []

  def index(conn, _params) do
    users =
      Accounts.list_users()
      |> Accounts.attach_surgeon_data()

    render(conn, "index.json", users: users)
  end

  # def create(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.user_path(conn, :show, user))
  #     |> render("show.json", user: user)
  #   end
  # end

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

  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)

  #   with {:ok, %User{}} <- Accounts.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end

  def set_password(conn, %{"token" => token}) do
    with {:ok, user_id} <- ActivationToken.verify(token),
         %User{password_hash: nil} = user <- Accounts.get_user!(user_id) do
      changeset = Accounts.change_user(user)
      render(conn, "set_password.html", changeset: changeset, user: user)
    else
      %User{password_hash: password_hash} when is_binary(password_hash) ->
        conn
        |> put_flash(:error, "You already have a password set.")
        |> redirect(to: "/")

      _ ->
        render(conn, "invalid_token.html")
    end
  end

  def set_password(conn, _) do
    # If there is no token in our params, tell the user they've provided
    # an invalid token or expired token
    conn
    |> put_flash(:error, "The verification link is invalid.")
    |> redirect(to: "/")
  end
end
