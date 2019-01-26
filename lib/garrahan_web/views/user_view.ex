defmodule GarrahanWeb.UserView do
  use GarrahanWeb, :view
  alias GarrahanWeb.UserView
  alias GarrahanWeb.SurgeonView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_with_surgeon_data.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_with_surgeon_data.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, isAdmin: user.is_admin, disabled: user.disabled}
  end

  def render("user_with_surgeon_data.json", %{user: {user, surgeon}}) do
    render_one(surgeon, SurgeonView, "surgeon.json")
    |> Map.put(:surgeonId, surgeon.id)
    |> Map.merge(render("user.json", %{user: user}))
  end
end
