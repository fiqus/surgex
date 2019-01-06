defmodule Garrahan.Auth.AuthErrorHandler do
  @moduledoc false

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    send_resp(conn, 401, to_string(type))
  end
end
