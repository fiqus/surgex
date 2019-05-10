defmodule Surgex.Accounts.ActivationToken do
  @moduledoc """
  Handles creating and validating tokens for user activation.
  """

  alias Surgex.Accounts.User

  @user_verification_salt Application.get_env(:surgex, :user_verification_salt)

  def generate(%User{id: user_id}) do
    Phoenix.Token.sign(SurgexWeb.Endpoint, @user_verification_salt, user_id)
  end

  def verify(token) do
    # tokens that are older than a day should be invalid
    max_age = 86_400

    Phoenix.Token.verify(SurgexWeb.Endpoint, @user_verification_salt, token, max_age: max_age)
  end
end
