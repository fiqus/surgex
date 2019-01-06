defmodule Garrahan.Auth.AuthAccessPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :garrahan,
    module: Garrahan.Auth.Guardian,
    error_handler: Garrahan.Auth.AuthErrorHandler

  # If there is an authorization header, validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Ensure there is an authenticated user
  plug Guardian.Plug.EnsureAuthenticated
  # Load the authenticated user
  plug Guardian.Plug.LoadResource

  plug Garrahan.Auth.Plug.CurrentUser
end
