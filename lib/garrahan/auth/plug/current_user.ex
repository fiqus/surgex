defmodule Garrahan.Auth.Plug.CurrentUser do
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    {user, surgeon} =
      current_resource(conn)
      |> format_resource()

    conn
    |> assign(:current_user, user)
    |> assign(:current_surgeon, surgeon)
  end

  defp format_resource(nil), do: {nil, nil}
  defp format_resource({_user, _surgeon} = resource), do: resource
end
