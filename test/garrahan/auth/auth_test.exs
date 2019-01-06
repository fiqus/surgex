defmodule Garrahan.AuthTest do
  use GarrahanWeb.ConnCase

  alias Garrahan.{Accounts, Auth}

  @user_attrs %{
    email: "test@garrahan.com",
    name: "testuser",
    password: "password"
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Accounts.create_user()

    {:ok, user: user}
  end

  describe "authenticate_user" do
    setup [:user_fixture]

    test "the user is found by email and password checked" do
      assert {:ok, _user} = Auth.authenticate_user(@user_attrs.email, @user_attrs.password)
    end

    test "the user/email does not exist" do
      assert {:error, "EMAIL_NOT_EXISTS"} =
               Auth.authenticate_user("another_email@email.com", "password")
    end

    test "cannot authenticate becase the user is disabled" do
      {:ok, user} =
        Enum.into(%{email: "another@garrahan.com", disabled: true}, @user_attrs)
        |> Accounts.create_user()

      assert {:error, "USER_DISABLED"} = Auth.authenticate_user(user.email, @user_attrs.password)
    end

    test "the user is found by email but wrong password" do
      assert {:error, "WRONG_PASSWORD"} = Auth.authenticate_user(@user_attrs.email, "badpass")
    end
  end

  describe "token" do
    setup [:user_fixture]

    test "should return an access token", %{user: user} do
      assert {:ok, token} = Auth.token(user)
      assert String.length(token) > 100
    end
  end
end
