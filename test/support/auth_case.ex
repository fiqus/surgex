defmodule GarrahanWeb.AuthCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      def auth_user(conn, user) do
        {:ok, token} = Garrahan.Auth.token(user)

        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")
      end
    end
  end

  setup do
    {:ok, admin} =
      Garrahan.Accounts.create_user(%{
        email: "admin@garrahan.com",
        name: "admin",
        password: "password",
        is_admin: true
      })

    {:ok, user} =
      Garrahan.Accounts.create_user(%{
        email: "user@garrahan.com",
        name: "user",
        password: "password",
        is_admin: false
      })

    {:ok, admin: admin, user: user}
  end
end
