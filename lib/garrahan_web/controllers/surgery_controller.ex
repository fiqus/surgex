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
    surgeries = Surgeries.list_surgeries(current_surgeon(conn))
    render(conn, "index.json", surgeries: surgeries)
  end

  def create(conn, %{"surgery" => surgery_params}) do
    photos = decode_photos_to_list(surgery_params["encoded_photos"])

    surgery_params = Map.put(surgery_params, "photos", photos)

    with {:ok, %Surgery{} = surgery} <- Surgeries.create_surgery(surgery_params),
         surgery <- Surgeries.preload_surgery_associations(surgery) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.surgery_path(conn, :show, surgery))
      |> render("show.json", surgery: surgery)
    end
  end

  defp decode_photos_to_list(encoded_photos) when is_list(encoded_photos) do
    encoded_photos
    |> Enum.with_index()
    |> Enum.map(fn {photo, index} ->
      "data:image/jpeg;base64," <> raw = photo
      {:ok, data} = Base.decode64(raw)
      :ok = File.write("/tmp/file.gif", data, [:binary])
      "file#{index}.gif"
    end)
  end

  defp decode_photos_to_list(_), do: []

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
