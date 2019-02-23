defmodule GarrahanWeb.UserControllerTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.Accounts.User

  import GarrahanWeb.AuthCase

  @update_attrs %{password: "some updated password", is_admin: true}
  @invalid_attrs %{password: nil}

  setup %{conn: conn, admin: admin} do
    {:ok, conn: auth_user(conn, admin)}
  end

  describe "index" do
    test_auth_admin_required(fn conn, _params ->
      get(conn, Routes.user_path(conn, :index))
    end)

    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert [%{}, %{}] = json_response(conn, 200)["data"]
    end
  end

  describe "create user" do
    test "can't create users directly - endpoint doesn't exist", %{conn: conn} do
      assert_error_sent 500, fn ->
        post(conn, Routes.user_path(conn, :create), user: %{})
      end
    end
  end

  describe "update user" do
    test_auth_admin_required(fn conn, %{user: user} ->
      put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
    end)

    test "renders user when data is valid", %{
      conn: conn,
      user: %User{id: id} = user,
      auth_surgeon: surgeon
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => user.id,
               "disabled" => user.disabled,
               "isAdmin" => @update_attrs.is_admin,
               "surgeonId" => surgeon.id,
               "email" => surgeon.email,
               "firstName" => surgeon.first_name,
               "lastName" => surgeon.last_name,
               "license" => nil
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    test "can't delete users directly - endpoint doesn't exist", %{conn: conn, user: user} do
      assert_error_sent 500, fn ->
        delete(conn, Routes.user_path(conn, :delete, user))
      end
    end
  end
end
