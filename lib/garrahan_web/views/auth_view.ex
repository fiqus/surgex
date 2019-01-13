defmodule GarrahanWeb.AuthView do
  use GarrahanWeb, :view

  def render("token.json", %{token: token, user: user}) do
    %{
      status: :success,
      token: token,
      user: %{
        id: user.id,
        email: user.email,
        admin: user.is_admin
      }
    }
  end

  def render("error.json", %{error: error}) do
    %{status: :error, reason: error}
  end
end
