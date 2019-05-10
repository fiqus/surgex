defmodule Surgex.Auth.LoadResourcePipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :surgex,
    module: Surgex.Auth.Guardian,
    error_handler: Surgex.Auth.AuthErrorHandler

  # If there is an authorization header, validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug Surgex.Auth.Plug.CurrentUser
end
