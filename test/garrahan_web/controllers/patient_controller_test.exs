defmodule GarrahanWeb.PatientControllerTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.Surgeries
  alias Garrahan.Surgeries.Patient

  import GarrahanWeb.AuthCase

  @create_attrs %{
    address: "some address",
    birthdate: ~D[2010-04-17],
    city: "some city",
    first_name: "some first_name",
    last_name: "some last_name",
    province: "some province"
  }
  @update_attrs %{
    address: "some updated address",
    birthdate: ~D[2011-05-18],
    city: "some updated city",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    province: "some updated province"
  }
  @invalid_attrs %{
    address: nil,
    birthdate: nil,
    city: nil,
    first_name: nil,
    last_name: nil,
    province: nil
  }

  def fixture(:patient) do
    {:ok, patient} = Surgeries.create_patient(@create_attrs)
    patient
  end

  setup %{conn: conn, user: user} do
    {:ok, conn: auth_user(conn, user)}
  end

  describe "index" do
    test_auth_user_required(fn conn, _params ->
      get(conn, Routes.patient_path(conn, :index))
    end)

    test "lists all patients", %{conn: conn} do
      conn = get(conn, Routes.patient_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create patient" do
    test_auth_user_required(fn conn, _params ->
      post(conn, Routes.patient_path(conn, :create), patient: @create_attrs)
    end)

    test "renders patient when data is valid", %{conn: conn} do
      conn = post(conn, Routes.patient_path(conn, :create), patient: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.patient_path(conn, :show, id))

      assert %{
               "id" => id,
               "socialId" => nil,
               "medicalHistory" => nil,
               "email" => nil,
               "phone" => nil,
               "nationality" => nil,
               "firstName" => "some first_name",
               "lastName" => "some last_name",
               "address" => "some address",
               "birthdate" => "2010-04-17",
               "city" => "some city",
               "province" => "some province"
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.patient_path(conn, :create), patient: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update patient" do
    setup [:create_patient]

    test_auth_user_required(fn conn, params ->
      put(conn, Routes.patient_path(conn, :update, params.patient), patient: @update_attrs)
    end)

    test "renders patient when data is valid", %{conn: conn, patient: %Patient{id: id} = patient} do
      conn = put(conn, Routes.patient_path(conn, :update, patient), patient: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.patient_path(conn, :show, id))

      assert %{
               "id" => id,
               "socialId" => nil,
               "medicalHistory" => nil,
               "email" => nil,
               "phone" => nil,
               "nationality" => nil,
               "firstName" => "some updated first_name",
               "lastName" => "some updated last_name",
               "address" => "some updated address",
               "birthdate" => "2011-05-18",
               "city" => "some updated city",
               "province" => "some updated province"
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, patient: patient} do
      conn = put(conn, Routes.patient_path(conn, :update, patient), patient: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete patient" do
    setup [:create_patient]

    test_auth_user_required(fn conn, params ->
      delete(conn, Routes.patient_path(conn, :delete, params.patient))
    end)

    test "deletes chosen patient", %{conn: conn, patient: patient} do
      conn = delete(conn, Routes.patient_path(conn, :delete, patient))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.patient_path(conn, :show, patient))
      end
    end
  end

  defp create_patient(_) do
    patient = fixture(:patient)
    {:ok, patient: patient}
  end
end
