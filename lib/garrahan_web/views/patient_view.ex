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
      first_name: patient.first_name,
      last_name: patient.last_name,
      birthdate: patient.birthdate,
      city: patient.city,
      province: patient.province,
      address: patient.address
    }
  end
end
