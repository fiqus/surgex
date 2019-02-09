defmodule GarrahanWeb.SurgeonController do
  use GarrahanWeb, :controller

  require Logger

  alias Garrahan.{Surgeries, Mailer, Email}
  alias Garrahan.Accounts
  alias Garrahan.Accounts.{User, ActivationToken}
  alias Garrahan.Surgeries.Surgeon

  action_fallback GarrahanWeb.FallbackController

  def index(conn, _params) do
    surgeons = Surgeries.list_surgeons()
    render(conn, "index.json", surgeons: surgeons)
  end

  def create(conn, %{"user" => user_params, "surgeon" => surgeon_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, %Surgeon{} = surgeon} <- Surgeries.create_surgeon(surgeon_params, user) do
      surgeon = Surgeries.preload_surgeon_user(surgeon)
      token = ActivationToken.generate(surgeon.user)
      activation_url = Routes.user_url(conn, :set_password, token: token)

      try do
        Email.set_password_email(surgeon, activation_url) |> Mailer.deliver_now()
      rescue
        error ->
          mailer_error_msg = "There was an error sending the email to #{surgeon.email}"
          Logger.error("#{mailer_error_msg} :: #{inspect(error)}")
      end

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.surgeon_path(conn, :show, surgeon))
      |> render("show.json", surgeon: surgeon)
    end
  end

  def show(conn, %{"id" => id}) do
    surgeon = Surgeries.get_surgeon!(id)
    render(conn, "show.json", surgeon: surgeon)
  end

  def update(conn, %{"id" => id, "surgeon" => surgeon_params}) do
    surgeon = Surgeries.get_surgeon!(id)

    with {:ok, %Surgeon{} = surgeon} <- Surgeries.update_surgeon(surgeon, surgeon_params) do
      render(conn, "show.json", surgeon: surgeon)
    end
  end

  def delete(conn, %{"id" => id}) do
    surgeon = Surgeries.get_surgeon!(id)

    with {:ok, %Surgeon{}} <- Surgeries.delete_surgeon(surgeon) do
      send_resp(conn, :no_content, "")
    end
  end
end
