defmodule GarrahanWeb.SurgeryControllerTest do
  use GarrahanWeb.ConnCase

  alias Garrahan.Surgeries
  alias Garrahan.Surgeries.Surgery

  @create_attrs %{
    date: ~D[2010-04-17],
    medical_history: "some medical_history"
  }
  @update_attrs %{
    date: ~D[2011-05-18],
    medical_history: "some updated medical_history"
  }
  @invalid_attrs %{date: nil, medical_history: nil}

  def fixture(:surgery) do
    {:ok, surgery} = Surgeries.create_surgery(@create_attrs)
    surgery
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all surgeries", %{conn: conn} do
      conn = get(conn, Routes.surgery_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create surgery" do
    test "renders surgery when data is valid", %{conn: conn} do
      conn = post(conn, Routes.surgery_path(conn, :create), surgery: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.surgery_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2010-04-17",
               "medical_history" => "some medical_history"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.surgery_path(conn, :create), surgery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update surgery" do
    setup [:create_surgery]

    test "renders surgery when data is valid", %{conn: conn, surgery: %Surgery{id: id} = surgery} do
      conn = put(conn, Routes.surgery_path(conn, :update, surgery), surgery: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.surgery_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2011-05-18",
               "medical_history" => "some updated medical_history"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, surgery: surgery} do
      conn = put(conn, Routes.surgery_path(conn, :update, surgery), surgery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete surgery" do
    setup [:create_surgery]

    test "deletes chosen surgery", %{conn: conn, surgery: surgery} do
      conn = delete(conn, Routes.surgery_path(conn, :delete, surgery))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.surgery_path(conn, :show, surgery))
      end
    end
  end

  defp create_surgery(_) do
    surgery = fixture(:surgery)
    {:ok, surgery: surgery}
  end
end
