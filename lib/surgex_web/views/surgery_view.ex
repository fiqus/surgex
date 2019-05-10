defmodule SurgexWeb.SurgeryView do
  use SurgexWeb, :view
  alias SurgexWeb.SurgeryView
  alias SurgexWeb.DiagnosticView
  alias SurgexWeb.PatientView
  alias SurgexWeb.SurgeonView

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
      comments: surgery.comments,
      diagnostic: render_one(surgery.diagnostic, DiagnosticView, "diagnostic.json"),
      patient: render_one(surgery.patient, PatientView, "patient.json"),
      surgeon: render_one(surgery.surgeon, SurgeonView, "surgeon.json"),
      assistants: render_many(surgery.assistants, SurgeonView, "surgeon.json"),
      photos: render_many(surgery.photos, SurgeryView, "photo.json", as: :photo)
    }
  end

  def render("photo.json", %{photo: photo}) do
    %{
      id: photo.id,
      name: photo.filename
    }
  end
end
