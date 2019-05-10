defmodule SurgexWeb.DiagnosticControllerTest do
  use SurgexWeb.ConnCase
  use SurgexWeb.AuthCase

  alias Surgex.Surgeries
  alias Surgex.Surgeries.Diagnostic

  import SurgexWeb.AuthCase

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:diagnostic) do
    {:ok, diagnostic} = Surgeries.create_diagnostic(@create_attrs)
    diagnostic
  end

  setup %{conn: conn, user: user} do
    {:ok, conn: auth_user(conn, user)}
  end

  describe "index" do
    test_auth_user_required(fn conn, _params ->
      get(conn, Routes.diagnostic_path(conn, :index))
    end)

    test "lists all diagnostics", %{conn: conn} do
      conn = get(conn, Routes.diagnostic_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create diagnostic" do
    test_auth_user_required(fn conn, _params ->
      post(conn, Routes.diagnostic_path(conn, :create), diagnostic: @create_attrs)
    end)

    test "renders diagnostic when data is valid", %{conn: conn} do
      conn = post(conn, Routes.diagnostic_path(conn, :create), diagnostic: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.diagnostic_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.diagnostic_path(conn, :create), diagnostic: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update diagnostic" do
    setup [:create_diagnostic]

    test_auth_user_required(fn conn, params ->
      put(conn, Routes.diagnostic_path(conn, :update, params.diagnostic),
        diagnostic: @update_attrs
      )
    end)

    test "renders diagnostic when data is valid", %{
      conn: conn,
      diagnostic: %Diagnostic{id: id} = diagnostic
    } do
      conn =
        put(conn, Routes.diagnostic_path(conn, :update, diagnostic), diagnostic: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.diagnostic_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, diagnostic: diagnostic} do
      conn =
        put(conn, Routes.diagnostic_path(conn, :update, diagnostic), diagnostic: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete diagnostic" do
    setup [:create_diagnostic]

    test_auth_user_required(fn conn, params ->
      delete(conn, Routes.diagnostic_path(conn, :delete, params.diagnostic))
    end)

    test "deletes chosen diagnostic", %{conn: conn, diagnostic: diagnostic} do
      conn = delete(conn, Routes.diagnostic_path(conn, :delete, diagnostic))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.diagnostic_path(conn, :show, diagnostic))
      end
    end
  end

  defp create_diagnostic(_) do
    diagnostic = fixture(:diagnostic)
    {:ok, diagnostic: diagnostic}
  end
end
