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
        password: "password",
        is_admin: true
      })

    {:ok, user} =
      Garrahan.Accounts.create_user(%{
        password: "password"
      })

    Garrahan.Surgeries.create_surgeon(
      %{
        email: "admin@garrahan.com",
        first_name: "Fiqus",
        last_name: "Admin"
      },
      admin
    )

    {:ok, surgeon} =
      Garrahan.Surgeries.create_surgeon(
        %{
          email: "user@garrahan.com",
          first_name: "Fiqus",
          last_name: "User"
        },
        user
      )

    {:ok, admin: admin, user: user, surgeon: surgeon}
  end

  defmacro test_auth_admin_required(func) do
    quote do
      test "403 if user is not admin", params do
        conn =
          auth_user(params.conn, params.user)
          |> unquote(func).(params)

        assert %{
                 "status" => "error",
                 "reason" => "ADMIN_REQUIRED"
               } = json_response(conn, 403)
      end
    end
  end

  defmacro test_auth_user_required(func) do
    quote do
      test "401 if user is not authenticated", params do
        conn =
          put_req_header(params.conn, "authorization", "Bearer invalid")
          |> unquote(func).(params)

        assert %{
                 "status" => "error",
                 "reason" => "AUTHORIZATION_REQUIRED"
               } = json_response(conn, 401)
      end
    end
  end
end
