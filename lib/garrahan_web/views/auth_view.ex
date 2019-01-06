defmodule GarrahanWeb.AuthView do
  use GarrahanWeb, :view

  def render("token.json", %{token: token}) do
    %{status: :ok, token: token}
  end

  def render("error.json", %{error: error}) do
    %{status: :error, reason: error}
  end
end
