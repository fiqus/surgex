defmodule Surgex.Accounts.RecoverToken do
  @moduledoc """
  Handles creating and validating tokens for user recovery.
  """

  @user_recover_salt Application.get_env(:surgex, :user_recover_salt)

  def generate(email) do
    Phoenix.Token.sign(SurgexWeb.Endpoint, @user_recover_salt, email)
  end

  def verify(token) do
    # tokens that are older than a hour should be invalid
    max_age = 3600

    Phoenix.Token.verify(SurgexWeb.Endpoint, @user_recover_salt, token, max_age: max_age)
  end
end
