defmodule SurgexWeb.PatientView do
  use SurgexWeb, :view
  alias SurgexWeb.PatientView

  def render("index.json", %{patients: patients}) do
    %{data: render_many(patients, PatientView, "patient.json")}
  end

  def render("show.json", %{patient: patient}) do
    %{data: render_one(patient, PatientView, "patient.json")}
  end

  def render("patient.json", %{patient: patient}) do
    %{
      id: patient.id,
      social_id: patient.social_id,
      medical_history: patient.medical_history,
      first_name: patient.first_name,
      last_name: patient.last_name,
      email: patient.email,
      phone: patient.phone,
      birthdate: patient.birthdate,
      nationality: patient.nationality,
      address: patient.address,
      city: patient.city,
      province: patient.province
    }
  end
end
