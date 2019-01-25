defmodule GarrahanWeb.AuthView do
  use GarrahanWeb, :view

  def render("token.json", %{token: token, surgeon: surgeon}) do
    %{
      status: :success,
      token: token,
      user: %{
        userId: surgeon.user.id,
        isAdmin: surgeon.user.is_admin,
        surgeonId: surgeon.id,
        email: surgeon.email,
        firstName: surgeon.first_name,
        lastName: surgeon.last_name,
        license: surgeon.license
      }
    }
  end

  def render("error.json", %{error: error}) do
    %{status: :error, reason: error}
  end
end
