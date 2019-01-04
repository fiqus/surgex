defmodule GarrahanWeb.SurgeonController do
  use GarrahanWeb, :controller

  alias Garrahan.Surgeries
  alias Garrahan.Surgeries.Surgeon

  action_fallback GarrahanWeb.FallbackController

  def index(conn, _params) do
    surgeons = Surgeries.list_surgeons()
    render(conn, "index.json", surgeons: surgeons)
  end

  def create(conn, %{"surgeon" => surgeon_params}) do
    with {:ok, %Surgeon{} = surgeon} <- Surgeries.create_surgeon(surgeon_params) do
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
