defmodule GarrahanWeb.SurgeryControllerTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.Surgeries
  alias Garrahan.Surgeries.Surgery

  import GarrahanWeb.AuthCase

  @create_attrs %{
    date: ~D[2010-04-17]
  }
  @update_attrs %{
    date: ~D[2011-05-18]
  }
  @invalid_attrs %{date: nil}

  def fixture(attrs) do
    {:ok, surgery} = Surgeries.create_surgery(attrs)
    surgery
  end

  setup %{conn: conn, user: user} do
    {:ok, conn: auth_user(conn, user)}
  end

  describe "index" do
    setup [:create_surgery_with_surgeon]

    test_auth_user_required(fn conn, _params ->
      get(conn, Routes.surgery_path(conn, :index))
    end)

    test "list all surgeries", %{conn: conn, surgery: %Surgery{id: id}} do
      conn = get(conn, Routes.surgery_path(conn, :index, filter: "all"))

      assert [
               %{
                 "id" => ^id,
                 "date" => "2010-04-17"
               }
             ] = json_response(conn, 200)["data"]
    end

    test "lists current surgeon surgeries", %{conn: conn, surgery: %Surgery{id: id}} do
      conn = get(conn, Routes.surgery_path(conn, :index))

      assert [
               %{
                 "id" => ^id,
                 "date" => "2010-04-17"
               }
             ] = json_response(conn, 200)["data"]
    end
  end

  describe "create surgery" do
    test_auth_user_required(fn conn, _params ->
      post(conn, Routes.surgery_path(conn, :create), surgery: @create_attrs)
    end)

    test "renders surgery when data is valid", %{conn: conn} do
      conn = post(conn, Routes.surgery_path(conn, :create), surgery: @create_attrs)
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
    setup [:create_surgery]

    test_auth_user_required(fn conn, params ->
      put(conn, Routes.surgery_path(conn, :update, params.surgery), surgery: @update_attrs)
    end)

    test "renders surgery when data is valid", %{conn: conn, surgery: %Surgery{id: id} = surgery} do
      conn = put(conn, Routes.surgery_path(conn, :update, surgery), surgery: @update_attrs)
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

  defp create_surgery(_) do
    surgery = fixture(@create_attrs)
    {:ok, surgery: surgery}
  end

  defp create_surgery_with_surgeon(params) do
    surgery =
      Map.put(@create_attrs, :surgeon_id, params.surgeon.id)
      |> fixture

    {:ok, surgery: surgery}
  end
end
