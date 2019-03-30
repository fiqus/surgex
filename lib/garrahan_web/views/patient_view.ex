defmodule GarrahanWeb.PatientView do
  use GarrahanWeb, :view
  alias GarrahanWeb.PatientView

  def render("index.json", %{patients: patients}) do
    %{data: render_many(patients, PatientView, "patient.json")}
  end

  def render("show.json", %{patient: patient}) do
    %{data: render_one(patient, PatientView, "patient.json")}
  end

  def render("patient.json", %{patient: patient}) do
    %{
      id: patient.id,
      socialId: patient.social_id,
      medicalHistory: patient.medical_history,
      firstName: patient.first_name,
      lastName: patient.last_name,
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
