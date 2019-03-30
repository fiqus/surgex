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
      socialId: surgeon.social_id,
      license: surgeon.license,
      firstName: surgeon.first_name,
      lastName: surgeon.last_name,
      email: surgeon.email,
      phone: surgeon.phone,
      birthdate: surgeon.birthdate,
      nationality: surgeon.nationality,
      address: surgeon.address,
      city: surgeon.city,
      province: surgeon.province
    }
  end
end
