defmodule Garrahan.Auth.LoadResourcePipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :garrahan,
    module: Garrahan.Auth.Guardian,
    error_handler: Garrahan.Auth.AuthErrorHandler

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.LoadResource, allow_blank: true)
  plug(Garrahan.Auth.Plug.CurrentUser)
end
