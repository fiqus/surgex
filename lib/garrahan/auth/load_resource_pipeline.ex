defmodule Garrahan.Auth.LoadResourcePipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :garrahan,
    module: Garrahan.Auth.Guardian,
    error_handler: Garrahan.Auth.AuthErrorHandler

  # If there is an authorization header, validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug Garrahan.Auth.Plug.CurrentUser
end
