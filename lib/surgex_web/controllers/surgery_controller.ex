defmodule SurgexWeb.SurgeryController do
  use SurgexWeb, :controller

  alias Surgex.Surgeries
  alias Surgex.Surgeries.Surgery

  action_fallback SurgexWeb.FallbackController

  def index(conn, %{"filter" => "all"}) do
    surgeries = Surgeries.list_surgeries()
    render(conn, "index.json", surgeries: surgeries)
  end

  def index(conn, _params) do
    surgeries = Surgeries.list_surgeries(current_surgeon(conn))
    render(conn, "index.json", surgeries: surgeries)
  end

  def create(conn, %{"surgery" => surgery_params}) do
    photos = decode_photos_to_list(surgery_params["added_photos"])
    surgery_params = Map.put(surgery_params, "added_photos", photos)

    with {:ok, %Surgery{} = surgery} <- Surgeries.create_surgery(surgery_params),
         surgery <- Surgeries.preload_surgery_associations(surgery) do
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
    added_photos = decode_photos_to_list(surgery_params["added_photos"])
    surgery_params = Map.put(surgery_params, "added_photos", added_photos)

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

  defp decode_photos_to_list(encoded_photos) when is_list(encoded_photos) do
    encoded_photos
    |> Enum.reduce([], fn photo, acc ->
      with parsed <- parse_photo_data!(photo) do
        [parsed | acc]
      else
        _ ->
          acc
      end
    end)
  end

  defp decode_photos_to_list(_), do: []

  defp parse_photo_data!(%{"name" => name, "type" => type, "data" => data} = photo) do
    prefix = "data:#{type};base64,"
    {:ok, regex} = Regex.compile("^#{prefix}")

    if !(String.match?(type, ~r/^image\//) && String.match?(data, regex)) do
      raise "not_an_image"
    end

    raw = String.replace_prefix(data, prefix, "")
    {:ok, decoded} = Base.decode64(raw)
    md5 = :crypto.hash(:md5, decoded) |> Base.encode16()

    photo
    |> Map.put("name", "#{md5}-#{name}")
    |> Map.put("md5", md5)
    |> Map.put("data", decoded)
  end

  defp parse_photo_data!(_), do: raise("missing_data")
end