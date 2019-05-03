defmodule Garrahan.Surgeries.Surgery do
  use Ecto.Schema

  import Ecto.Changeset

  require Logger

  alias Garrahan.Repo
  alias Garrahan.Surgeries.{Patient, Surgeon, Diagnostic, Photo}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "surgeries" do
    field :date, :date
    field :comments, :string
    belongs_to(:patient, Patient)
    belongs_to(:surgeon, Surgeon)
    belongs_to(:diagnostic, Diagnostic)

    many_to_many(
      :assistants,
      Surgeon,
      join_through: "surgeries_surgeons",
      on_replace: :delete,
      on_delete: :delete_all
    )

    has_many(:photos, Photo, on_replace: :delete, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(surgery, attrs) do
    surgery
    |> cast(attrs, [:date, :comments, :surgeon_id, :diagnostic_id, :patient_id])
    |> validate_required([:date, :surgeon_id, :patient_id])
    |> foreign_key_constraint(:surgeon_id)
    |> foreign_key_constraint(:diagnostic_id)
    |> foreign_key_constraint(:patient_id)
    |> put_assoc(:assistants, parse_assistants(attrs))
    |> put_assoc(:photos, parse_photos(attrs, Repo.preload(surgery, :photos).photos))
  end

  defp parse_assistants(attrs) do
    (attrs[:assistants] || attrs["assistants"] || [])
    |> Enum.map(&get_assistant/1)
    |> Enum.reject(&(&1 == nil))
  end

  defp get_assistant(%Surgeon{} = assistant), do: assistant
  defp get_assistant(%{"id" => id}), do: get_assistant(id)

  defp get_assistant(assistant_id) when is_binary(assistant_id) do
    Repo.get(Surgeon, assistant_id)
  end

  defp parse_photos(%{"added_photos" => added, "removed_photos" => removed}, current_photos) do
    added_photos =
      added
      |> Enum.map(&save_added_photo/1)
      |> Enum.reject(&(&1 == nil))

    added_photos ++
      (current_photos
       |> Enum.reject(fn cp ->
         removed
         |> Enum.find(&(&1 == cp.id))
         |> maybe_remove_and_continue(cp)
       end))
  end

  defp parse_photos(_, current_photos), do: current_photos

  defp maybe_remove_and_continue(nil, _photo), do: false

  defp maybe_remove_and_continue(_id, %{filename: filename}) do
    path = Application.get_env(:garrahan, :surgeries_photos_path) <> filename
    :ok = File.rm(path)
    true
  end

  defp save_added_photo(%{"name" => name, "type" => _type, "md5" => md5, "data" => data}) do
    try do
      photo =
        %Photo{}
        |> change(filename: name)
        |> change(md5: md5)

      path = Application.get_env(:garrahan, :surgeries_photos_path) <> name
      :ok = File.write(path, data, [:binary])
      photo
    rescue
      _ -> nil
    end
  end

  defp save_added_photo(_), do: nil
end
