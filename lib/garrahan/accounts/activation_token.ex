defmodule Garrahan.Accounts.ActivationToken do
  @moduledoc """
  Handles creating and validating tokens for user activation.
  """

  alias Garrahan.Accounts.User

  @user_verification_salt Application.get_env(:garrahan, :user_verification_salt)

  def generate(%User{id: user_id}) do
    Phoenix.Token.sign(GarrahanWeb.Endpoint, @user_verification_salt, user_id)
  end

  def verify(token) do
    # tokens that are older than a day should be invalid
    max_age = 86_400

    Phoenix.Token.verify(GarrahanWeb.Endpoint, @user_verification_salt, token, max_age: max_age)
  end
end
