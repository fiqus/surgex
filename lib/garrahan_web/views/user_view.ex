defmodule GarrahanWeb.UserView do
  use GarrahanWeb, :view
  alias GarrahanWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, is_admin: user.is_admin, disabled: user.disabled}
  end
end
