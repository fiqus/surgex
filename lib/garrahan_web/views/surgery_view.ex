defmodule GarrahanWeb.SurgeryView do
  use GarrahanWeb, :view
  alias GarrahanWeb.SurgeryView
  alias GarrahanWeb.SurgeonView
  alias GarrahanWeb.PatientView

  def render("index.json", %{surgeries: surgeries}) do
    %{data: render_many(surgeries, SurgeryView, "surgery.json")}
  end

  def render("show.json", %{surgery: surgery}) do
    %{data: render_one(surgery, SurgeryView, "surgery.json")}
  end

  def render("surgery.json", %{surgery: surgery}) do
    %{
      id: surgery.id,
      date: surgery.date,
      surgeon: render_one(surgery.surgeon, SurgeonView, "surgeon.json"),
      patient: render_one(surgery.patient, PatientView, "patient.json"),
      assistants: render_many(surgery.assistants, SurgeonView, "surgeon.json")
    }
  end
end
