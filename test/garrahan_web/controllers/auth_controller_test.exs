defmodule GarrahanWeb.AuthControllerTest do
  use GarrahanWeb.ConnCase

  alias Garrahan.Accounts
  alias Garrahan.Surgeries

  @auth_attrs %{
    email: "email@test.com",
    password: "testpass"
  }

  @user_attrs %{
    password: @auth_attrs.password
  }

  @surgeon_attrs %{
    email: @auth_attrs.email,
    first_name: "Test",
    last_name: "Testing"
  }

  def fixture(user_attrs, surgeon_attrs) do
    {:ok, user} = Accounts.create_user(user_attrs)
    {:ok, surgeon} = Map.put(surgeon_attrs, :user_id, user.id) |> Surgeries.create_surgeon()
    {user, surgeon}
  end

  describe "token" do
    test "should return an access token and some user data", %{conn: conn} do
      {user, surgeon} = fixture(@user_attrs, @surgeon_attrs)
      conn = post(conn, Routes.auth_path(conn, :token), @auth_attrs)

      assert %{
               "status" => "success",
               "token" => token,
               "user" => auth_user
             } = json_response(conn, 200)

      assert String.length(token) > 100
      assert auth_user["userId"] == user.id
      assert auth_user["surgeonId"] == surgeon.id
      assert auth_user["email"] == surgeon.email
      assert auth_user["firstName"] == surgeon.first_name
      assert auth_user["lastName"] == surgeon.last_name
    end

    test "should return an error because user is disabled", %{conn: conn} do
      fixture(Map.put(@user_attrs, :disabled, true), @surgeon_attrs)
      conn = post(conn, Routes.auth_path(conn, :token), @auth_attrs)

      assert %{
               "status" => "error",
               "reason" => "USER_DISABLED"
             } = json_response(conn, 200)
    end

    test "should return an error because email was not found", %{conn: conn} do
      fixture(@user_attrs, Map.put(@surgeon_attrs, :email, "another@email.com"))
      conn = post(conn, Routes.auth_path(conn, :token), @auth_attrs)

      assert %{
               "status" => "error",
               "reason" => "EMAIL_NOT_EXISTS"
             } = json_response(conn, 200)
    end

    test "should return an error because password is wrong", %{conn: conn} do
      fixture(Map.put(@user_attrs, :password, "anotherpass"), @surgeon_attrs)
      conn = post(conn, Routes.auth_path(conn, :token), @auth_attrs)

      assert %{
               "status" => "error",
               "reason" => "WRONG_PASSWORD"
             } = json_response(conn, 200)
    end
  end
end
