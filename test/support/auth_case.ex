defmodule GarrahanWeb.AuthCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      def loggin_user(conn, user) do
        {:ok, conn} = Garrahan.Auth.login(conn, user)
        conn
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
