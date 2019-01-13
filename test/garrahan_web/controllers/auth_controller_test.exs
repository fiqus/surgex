defmodule GarrahanWeb.AuthControllerTest do
  use GarrahanWeb.ConnCase

  alias Garrahan.Accounts

  @user_attrs %{
    email: "email@test.com",
    password: "testpass"
  }

  def fixture(attrs) do
    {:ok, user} = Accounts.create_user(attrs)
    user
  end

  describe "token" do
    test "should return an access token and some user data", %{conn: conn} do
      user = fixture(@user_attrs)
      conn = post(conn, Routes.auth_path(conn, :token), @user_attrs)

      assert %{
               "status" => "success",
               "token" => token,
               "user" => auth_user
             } = json_response(conn, 200)

      assert String.length(token) > 100
      assert auth_user["id"] == user.id
      assert auth_user["email"] == user.email
    end

    test "should return an error because user is disabled", %{conn: conn} do
      fixture(Map.put(@user_attrs, :disabled, true))
      conn = post(conn, Routes.auth_path(conn, :token), @user_attrs)

      assert %{
               "status" => "error",
               "reason" => "USER_DISABLED"
             } = json_response(conn, 200)
    end

    test "should return an error because email was not found", %{conn: conn} do
      fixture(Map.put(@user_attrs, :email, "another@email.com"))
      conn = post(conn, Routes.auth_path(conn, :token), @user_attrs)

      assert %{
               "status" => "error",
               "reason" => "EMAIL_NOT_EXISTS"
             } = json_response(conn, 200)
    end

    test "should return an error because password is wrong", %{conn: conn} do
      fixture(Map.put(@user_attrs, :password, "anotherpass"))
      conn = post(conn, Routes.auth_path(conn, :token), @user_attrs)

      assert %{
               "status" => "error",
               "reason" => "WRONG_PASSWORD"
             } = json_response(conn, 200)
    end
  end
end
