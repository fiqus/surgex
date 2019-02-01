defmodule GarrahanWeb.SurgeryView do
  use GarrahanWeb, :view
  alias GarrahanWeb.SurgeryView

  def render("index.json", %{surgeries: surgeries}) do
    %{data: render_many(surgeries, SurgeryView, "surgery.json")}
  end

  def render("show.json", %{surgery: surgery}) do
    %{data: render_one(surgery, SurgeryView, "surgery.json")}
  end

  def render("surgery.json", %{surgery: surgery}) do
    %{id: surgery.id, date: surgery.date}
  end
end
