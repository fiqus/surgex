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

  def render("auth.json", %{auth: auth}) do
    %{auth: auth}
  end

  def render("error.json", %{error: code}) do
    %{status: :error, code: code}
  end
end
