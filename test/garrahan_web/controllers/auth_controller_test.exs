defmodule GarrahanWeb.AuthControllerTest do
  use GarrahanWeb.ConnCase

  alias Garrahan.Accounts

  @user_attrs %{
    email: "email@test.com",
    password: "testpass"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  describe "token" do
    setup [:create_user]

    test "should return an access token", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :token), %{"data" => @user_attrs})

      assert %{
               "status" => "ok",
               "token" => token
             } = json_response(conn, 200)

      assert String.length(token) > 100
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
