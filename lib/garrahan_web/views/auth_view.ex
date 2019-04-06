defmodule GarrahanWeb.AuthView do
  use GarrahanWeb, :view

  def render("token.json", %{token: token, surgeon: surgeon}) do
    %{
      status: :success,
      token: token,
      user: %{
        userId: surgeon.user.id,
        is_admin: surgeon.user.is_admin,
        last_login: surgeon.user.last_login,
        surgeonId: surgeon.id,
        email: surgeon.email,
        first_name: surgeon.first_name,
        last_name: surgeon.last_name,
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
