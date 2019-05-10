defmodule Surgex.Auth.AuthAccessPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :surgex,
    module: Surgex.Auth.Guardian,
    error_handler: Surgex.Auth.AuthErrorHandler

  # If there is an authorization header, validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Ensure there is an authenticated user
  plug Guardian.Plug.EnsureAuthenticated
  # Load the authenticated user
  plug Guardian.Plug.LoadResource

  plug Surgex.Auth.Plug.CurrentUser
end
