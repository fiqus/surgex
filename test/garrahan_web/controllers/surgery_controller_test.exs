defmodule GarrahanWeb.SurgeryControllerTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.Surgeries.Surgery
  alias Garrahan.Fixtures

  import GarrahanWeb.AuthCase

  encoded_photo = Base.encode64("12wfd3rdf")

  @create_attrs %{
    date: ~D[2010-04-17],
    patient_id: "71695983-4e45-4025-ad58-17a7450f783b",
    surgeon_id: "11695983-4e45-4025-ad58-17a7450f783b",
    diagnostic_id: "73695983-4e45-4025-ad58-17a7450f783b",
    assistants: [
      "71695983-4e45-4025-ad58-17a7450f7831",
      "71695983-4e45-4025-ad58-17a7450f7833",
      "71695983-4e45-4025-ad58-17a7450f7834"
    ],
    encoded_photos: [
      "data:image/jpeg;base64,#{encoded_photo}",
      "data:image/jpeg;base64,#{encoded_photo}"
    ]
  }
  @update_attrs %{
    date: ~D[2011-05-18],
    photos: ["r334534.jpg"]
  }
  @invalid_attrs %{date: nil}

  def fixture(attrs, surgeon) do
    {:ok, patient} = Fixtures.create_patient()
    {:ok, assistant1} = Fixtures.create_surgeon(%{email: "assistant1@test.com", license: "1"})
    {:ok, assistant2} = Fixtures.create_surgeon(%{email: "assistant2@test.com", license: "2"})
    {:ok, assistant3} = Fixtures.create_surgeon(%{email: "assistant3@test.com", license: "3"})
    {:ok, diagnostic} = Fixtures.create_diagnostic(attrs)

    surgery_attrs = %{
      patient_id: patient.id,
      assistants: [assistant1, assistant2, assistant3],
      surgeon_id: surgeon.id,
      diagnostic_id: diagnostic.id
    }

    {:ok, surgery} = Fixtures.create_surgery(surgery_attrs)
    surgery |> Garrahan.Surgeries.preload_surgery_associations()
  end

  setup %{conn: conn, user: user} do
    {:ok, conn: auth_user(conn, user)}
  end

  describe "index" do
    setup [:create_surgery]

    test_auth_user_required(fn conn, _params ->
      get(conn, Routes.surgery_path(conn, :index))
    end)

    test "list all surgeries", %{conn: conn, surgery: %Surgery{}} do
      conn = get(conn, Routes.surgery_path(conn, :index, filter: "all"))

      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "lists current surgeon surgeries", %{
      conn: conn,
      surgery: %Surgery{id: id}
    } do
      conn = get(conn, Routes.surgery_path(conn, :index))
      assert hd(json_response(conn, 200)["data"])["id"] == id
    end
  end

  describe "create surgery" do
    setup [:create_patient, :create_surgeon, :create_diagnostic]

    test_auth_user_required(fn conn, _params ->
      post(conn, Routes.surgery_path(conn, :create), surgery: @create_attrs)
    end)

    test "renders surgery when data is valid", %{
      conn: conn,
      surgeon: surgeon,
      diagnostic: diagnostic,
      patient: patient
    } do
      create_attrs = %{
        @create_attrs
        | patient_id: patient.id,
          surgeon_id: surgeon.id,
          diagnostic_id: diagnostic.id
      }

      conn = post(conn, Routes.surgery_path(conn, :create), surgery: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.surgery_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2010-04-17"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.surgery_path(conn, :create), surgery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update surgery" do
    setup [:create_surgery, :create_patient, :create_surgeon, :create_diagnostic]

    test_auth_user_required(fn conn, params ->
      put(conn, Routes.surgery_path(conn, :update, params.surgery), surgery: @update_attrs)
    end)

    test "renders surgery when data is valid", %{
      conn: conn,
      surgery: %Surgery{id: id} = surgery,
      surgeon: surgeon,
      diagnostic: diagnostic,
      patient: patient
    } do
      update_attrs =
        @update_attrs
        |> Map.put(:patient_id, patient.id)
        |> Map.put(:surgeon_id, surgeon.id)
        |> Map.put(:diagnostic_id, diagnostic.id)

      conn = put(conn, Routes.surgery_path(conn, :update, surgery), surgery: update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.surgery_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2011-05-18"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, surgery: surgery} do
      conn = put(conn, Routes.surgery_path(conn, :update, surgery), surgery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete surgery" do
    setup [:create_surgery]

    test_auth_user_required(fn conn, params ->
      delete(conn, Routes.surgery_path(conn, :delete, params.surgery))
    end)

    test "deletes chosen surgery", %{conn: conn, surgery: surgery} do
      conn = delete(conn, Routes.surgery_path(conn, :delete, surgery))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.surgery_path(conn, :show, surgery))
      end
    end
  end

  defp create_surgery(%{surgeon: surgeon}) do
    surgery = fixture(@create_attrs, surgeon)
    {:ok, surgery: surgery}
  end

  defp create_patient(_) do
    {:ok, patient} = Fixtures.create_patient()
    {:ok, patient: patient}
  end

  defp create_surgeon(_) do
    {:ok, surgeon} =
      Fixtures.create_surgeon(%{
        email: "surgeon_new@test.com",
        licence: "licence_#{:rand.uniform(50)}"
      })

    {:ok, surgeon: surgeon}
  end

  defp create_diagnostic(_) do
    {:ok, diagnostic} = Fixtures.create_diagnostic()
    {:ok, diagnostic: diagnostic}
  end
end
