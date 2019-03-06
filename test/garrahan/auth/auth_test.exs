defmodule Garrahan.AuthTest do
  use GarrahanWeb.ConnCase
  use GarrahanWeb.AuthCase

  alias Garrahan.{Accounts, Auth}

  describe "authenticate_user" do
    test "the user is found by email and password checked", %{auth_surgeon: surgeon, user: user} do
      assert {:ok, authorizated_surgeon} = Auth.authenticate_user(surgeon.email, user.password)
      assert authorizated_surgeon.id == surgeon.id
      assert authorizated_surgeon.email == surgeon.email
      assert authorizated_surgeon.user.id == user.id
    end

    test "the user/email does not exist" do
      assert {:error, "EMAIL_NOT_EXISTS"} =
               Auth.authenticate_user("another_email@email.com", "password")
    end

    test "cannot authenticate becase the user is disabled", %{auth_surgeon: surgeon, user: user} do
      {:ok, _user} = Accounts.update_user(user, %{disabled: true})

      assert {:error, "USER_DISABLED"} = Auth.authenticate_user(surgeon.email, user.password)
    end

    test "the user is found by email but wrong password", %{auth_surgeon: surgeon} do
      assert {:error, "WRONG_PASSWORD"} = Auth.authenticate_user(surgeon.email, "badpass")
    end
  end

  describe "token" do
    test "should return an access token", %{user: user} do
      assert {:ok, token} = Auth.token(user)
      assert String.length(token) > 100
    end
  end

  describe "is_auth?" do
    test "should return true if token is valid", %{user: user} do
      {:ok, token} = Auth.token(user)
      assert Auth.is_auth?(token) == true
    end

    test "should return false if token is not valid" do
      assert Auth.is_auth?("wrong-token") == false
    end
  end
end
