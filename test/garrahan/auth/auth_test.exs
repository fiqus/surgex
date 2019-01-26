defmodule Garrahan.AuthTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.{Accounts, Auth}

  describe "authenticate_user" do
    test "the user is found by email and password checked", %{surgeon: surgeon, user: user} do
      assert {:ok, auth_surgeon} = Auth.authenticate_user(surgeon.email, user.password)
      assert auth_surgeon.id == surgeon.id
      assert auth_surgeon.email == surgeon.email
      assert auth_surgeon.user.id == user.id
    end

    test "the user/email does not exist" do
      assert {:error, "EMAIL_NOT_EXISTS"} =
               Auth.authenticate_user("another_email@email.com", "password")
    end

    test "cannot authenticate becase the user is disabled", %{surgeon: surgeon, user: user} do
      {:ok, _user} = Accounts.update_user(user, %{disabled: true})

      assert {:error, "USER_DISABLED"} = Auth.authenticate_user(surgeon.email, user.password)
    end

    test "the user is found by email but wrong password", %{surgeon: surgeon} do
      assert {:error, "WRONG_PASSWORD"} = Auth.authenticate_user(surgeon.email, "badpass")
    end
  end

  describe "token" do
    test "should return an access token", %{user: user} do
      assert {:ok, token} = Auth.token(user)
      assert String.length(token) > 100
    end
  end
end
