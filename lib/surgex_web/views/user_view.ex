defmodule SurgexWeb.UserView do
  use SurgexWeb, :view
  alias SurgexWeb.UserView
  alias SurgexWeb.SurgeonView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_with_surgeon_data.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_with_surgeon_data.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, last_login: user.last_login, is_admin: user.is_admin, disabled: user.disabled}
  end

  def render("surgeon.json", %{surgeon: surgeon}) do
    render_one(surgeon, SurgeonView, "surgeon.json")
  end

  def render("user_with_surgeon_data.json", %{user: {user, surgeon}}) do
    render("surgeon.json", %{surgeon: surgeon})
    |> Map.put(:surgeonId, surgeon.id)
    |> Map.merge(render("user.json", %{user: user}))
  end

  def render("error.json", %{error: code}) do
    %{status: :error, code: code}
  end
end
