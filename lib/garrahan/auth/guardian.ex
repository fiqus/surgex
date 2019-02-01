defmodule Garrahan.Auth.Guardian do
  @moduledoc false

  use Guardian, otp_app: :garrahan

  alias Garrahan.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    try do
      {user, surgeon} =
        Accounts.get_user!(id)
        |> Accounts.attach_surgeon_data()

      {:ok, {user, surgeon}}
    rescue
      _error ->
        {:error, :user_not_found}
    end
  end
end
