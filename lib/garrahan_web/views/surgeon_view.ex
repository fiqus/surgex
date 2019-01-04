defmodule GarrahanWeb.SurgeonView do
  use GarrahanWeb, :view
  alias GarrahanWeb.SurgeonView

  def render("index.json", %{surgeons: surgeons}) do
    %{data: render_many(surgeons, SurgeonView, "surgeon.json")}
  end

  def render("show.json", %{surgeon: surgeon}) do
    %{data: render_one(surgeon, SurgeonView, "surgeon.json")}
  end

  def render("surgeon.json", %{surgeon: surgeon}) do
    %{
      id: surgeon.id,
      first_name: surgeon.first_name,
      last_name: surgeon.last_name,
      license: surgeon.license
    }
  end
end
