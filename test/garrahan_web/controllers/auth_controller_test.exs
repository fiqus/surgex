defmodule GarrahanWeb.AuthControllerTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.Accounts

  describe "token" do
    test "should return an access token and some user data", %{
      conn: conn,
      auth_surgeon: surgeon,
      user: user
    } do
      conn =
        post(conn, Routes.auth_path(conn, :token), %{
          email: surgeon.email,
          password: user.password
        })

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

    test "should return an error because email was not found", %{conn: conn} do
      conn =
        post(conn, Routes.auth_path(conn, :token), %{
          email: "another@email.com",
          password: "password"
        })

      assert %{
               "status" => "error",
               "reason" => "EMAIL_NOT_EXISTS"
             } = json_response(conn, 200)
    end

    test "should return an error because user is disabled", %{
      conn: conn,
      auth_surgeon: surgeon,
      user: user
    } do
      {:ok, _user} = Accounts.update_user(user, %{disabled: true})

      conn =
        post(conn, Routes.auth_path(conn, :token), %{
          email: surgeon.email,
          password: user.password
        })

      assert %{
               "status" => "error",
               "reason" => "USER_DISABLED"
             } = json_response(conn, 200)
    end

    test "should return an error because password is wrong", %{conn: conn, auth_surgeon: surgeon} do
      conn =
        post(conn, Routes.auth_path(conn, :token), %{
          email: surgeon.email,
          password: "badpass"
        })

      assert %{
               "status" => "error",
               "reason" => "WRONG_PASSWORD"
             } = json_response(conn, 200)
    end
  end

  describe "is_auth" do
    test "should return %{'auth' => true} if token is valid", %{conn: conn, user: user} do
      {:ok, token} = Garrahan.Auth.token(user)
      conn = post(conn, Routes.auth_path(conn, :is_auth), %{token: token})

      assert %{"auth" => true} = json_response(conn, 200)
    end

    test "should return %{'auth' => false} if token is not valid", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :is_auth), %{token: "wrong-token"})

      assert %{"auth" => false} = json_response(conn, 200)
    end
  end
end
