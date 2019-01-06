defmodule GarrahanWeb.SurgeonControllerTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.Surgeries
  alias Garrahan.Surgeries.Surgeon

  @create_attrs %{
    first_name: "some first_name",
    last_name: "some last_name",
    license: "some license"
  }
  @update_attrs %{
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    license: "some updated license"
  }
  @invalid_attrs %{first_name: nil, last_name: nil, license: nil}

  def fixture(:surgeon) do
    {:ok, surgeon} = Surgeries.create_surgeon(@create_attrs)
    surgeon
  end

  setup %{conn: conn, user: user} do
    {:ok, conn: auth_user(conn, user)}
  end

  describe "index" do
    test "lists all surgeons", %{conn: conn} do
      conn = get(conn, Routes.surgeon_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create surgeon" do
    test "renders surgeon when data is valid", %{conn: conn} do
      conn = post(conn, Routes.surgeon_path(conn, :create), surgeon: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.surgeon_path(conn, :show, id))

      assert %{
               "id" => id,
               "first_name" => "some first_name",
               "last_name" => "some last_name",
               "license" => "some license"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.surgeon_path(conn, :create), surgeon: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update surgeon" do
    setup [:create_surgeon]

    test "renders surgeon when data is valid", %{conn: conn, surgeon: %Surgeon{id: id} = surgeon} do
      conn = put(conn, Routes.surgeon_path(conn, :update, surgeon), surgeon: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.surgeon_path(conn, :show, id))

      assert %{
               "id" => id,
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name",
               "license" => "some updated license"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, surgeon: surgeon} do
      conn = put(conn, Routes.surgeon_path(conn, :update, surgeon), surgeon: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete surgeon" do
    setup [:create_surgeon]

    test "deletes chosen surgeon", %{conn: conn, surgeon: surgeon} do
      conn = delete(conn, Routes.surgeon_path(conn, :delete, surgeon))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.surgeon_path(conn, :show, surgeon))
      end
    end
  end

  defp create_surgeon(_) do
    surgeon = fixture(:surgeon)
    {:ok, surgeon: surgeon}
  end
end
