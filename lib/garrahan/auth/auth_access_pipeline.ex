defmodule Garrahan.Auth.AuthAccessPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :btrz_web_admin,
    module: Garrahan.Auth.Guardian,
    error_handler: Garrahan.Auth.AuthErrorHandler

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
  plug(Garrahan.Auth.Plug.CurrentUser)
end
