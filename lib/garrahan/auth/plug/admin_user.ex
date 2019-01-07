defmodule Garrahan.Auth.Plug.AdminUser do
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = current_resource(conn)

    case is_user_admin?(current_user) do
      true ->
        conn

      false ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, encode_error())
        |> halt()
    end
  end

  defp is_user_admin?(%{is_admin: true}), do: true
  defp is_user_admin?(_), do: false

  defp encode_error() do
    Poison.encode!(%{
      "status" => "error",
      "reason" => "ADMIN_REQUIRED"
    })
  end
end
