defmodule Surgex.Auth.AuthErrorHandler do
  @moduledoc false

  import Plug.Conn

  def auth_error(conn, {_type, _reason}, _opts) do
    error = %{
      "status" => "error",
      "reason" => "AUTHORIZATION_REQUIRED"
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(error))
  end
end
