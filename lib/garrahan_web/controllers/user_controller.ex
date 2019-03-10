defmodule GarrahanWeb.UserController do
  use GarrahanWeb, :controller

  require Logger

  alias Garrahan.{Surgeries, Mailer, Email}
  alias Garrahan.Accounts
  alias Garrahan.Accounts.{ActivationToken, RecoverToken, User}

  action_fallback GarrahanWeb.FallbackController
  # Requires to be an admin!
  plug(Garrahan.Auth.Plug.AdminUser, [] when action not in [:recover, :activate])

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

  def recover(conn, %{"email" => email}) do
    with %Surgeries.Surgeon{} = surgeon <- Surgeries.get_surgeon_by_email(email) do
      token = RecoverToken.generate(email)
      recover_url = Routes.index_url(conn, :index) <> "#/users/recover/token?token=" <> token

      try do
        # @TODO How to "easily" test when this fails?
        Email.set_recover_email(surgeon, recover_url) |> Mailer.deliver_now()
        render(conn, "surgeon.json", surgeon: surgeon)
      rescue
        error ->
          mailer_error_msg = "There was an error sending the recovery email to #{surgeon.email}"
          Logger.error("#{mailer_error_msg} :: #{inspect(error)}")
          render_error(conn, "EMAIL_NOT_SENT")
      end
    else
      _ ->
        render_error(conn, "EMAIL_NOT_EXISTS")
    end
  end

  def recover(conn, %{"token" => token, "password" => password, "confirm" => confirm}) do
    with ^password <- confirm,
         {:ok, email} <- RecoverToken.verify(token),
         %Surgeries.Surgeon{} = surgeon <- Surgeries.get_surgeon_by_email(email),
         {:ok, %User{}} <- Accounts.update_user(surgeon.user, %{"password" => password}) do
      render(conn, "surgeon.json", surgeon: surgeon)
    else
      {:error, %Ecto.Changeset{errors: [password: _]}} ->
        render_error(conn, "PASSWORD_WEAK")

      _ when password != confirm ->
        render_error(conn, "PASSWORD_MISMATCH")

      _ ->
        render_error(conn, "WRONG_TOKEN")
    end
  end

  def recover(conn, %{"token" => token}) do
    with {:ok, email} <- RecoverToken.verify(token),
         %Surgeries.Surgeon{} = surgeon <- Surgeries.get_surgeon_by_email(email) do
      render(conn, "surgeon.json", surgeon: surgeon)
    else
      _ ->
        render_error(conn, "WRONG_TOKEN")
    end
  end

  def recover(conn, _) do
    render_error(conn, "WRONG_REQUEST")
  end

  def activate(conn, %{"token" => token, "password" => password, "confirm" => confirm}) do
    with ^password <- confirm,
         {:ok, user_id} <- ActivationToken.verify(token),
         %User{password_hash: nil} = user <- Accounts.get_user(user_id),
         {:ok, %User{} = user} <- Accounts.update_user(user, %{"password" => password}) do
      render(conn, "show.json", user: Accounts.attach_surgeon_data(user))
    else
      %User{password_hash: password_hash} when is_binary(password_hash) ->
        render_error(conn, "ALREADY_ACTIVATED")

      {:error, %Ecto.Changeset{errors: [password: _]}} ->
        render_error(conn, "PASSWORD_WEAK")

      _ when password != confirm ->
        render_error(conn, "PASSWORD_MISMATCH")

      _ ->
        render_error(conn, "WRONG_TOKEN")
    end
  end

  def activate(conn, %{"token" => token}) do
    with {:ok, user_id} <- ActivationToken.verify(token),
         %User{password_hash: nil} = user <- Accounts.get_user(user_id) do
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
