defmodule GarrahanWeb.SurgeryController do
  use GarrahanWeb, :controller

  alias Garrahan.Surgeries
  alias Garrahan.Surgeries.Surgery

  action_fallback GarrahanWeb.FallbackController

  def index(conn, %{"filter" => "all"}) do
    surgeries = Surgeries.list_surgeries()
    render(conn, "index.json", surgeries: surgeries)
  end

  def index(conn, _params) do
    current_surgeon = conn.assigns.current_surgeon
    surgeries = Surgeries.list_surgeries(current_surgeon.id)
    render(conn, "index.json", surgeries: surgeries)
  end

  def create(conn, %{"surgery" => surgery_params}) do
    with {:ok, %Surgery{} = surgery} <- Surgeries.create_surgery(surgery_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.surgery_path(conn, :show, surgery))
      |> render("show.json", surgery: surgery)
    end
  end

  def show(conn, %{"id" => id}) do
    surgery = Surgeries.get_surgery!(id)
    render(conn, "show.json", surgery: surgery)
  end

  def update(conn, %{"id" => id, "surgery" => surgery_params}) do
    surgery = Surgeries.get_surgery!(id)

    with {:ok, %Surgery{} = surgery} <- Surgeries.update_surgery(surgery, surgery_params) do
      render(conn, "show.json", surgery: surgery)
    end
  end

  def delete(conn, %{"id" => id}) do
    surgery = Surgeries.get_surgery!(id)

    with {:ok, %Surgery{}} <- Surgeries.delete_surgery(surgery) do
      send_resp(conn, :no_content, "")
    end
  end
end
