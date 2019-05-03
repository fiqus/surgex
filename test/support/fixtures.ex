defmodule Garrahan.Fixtures do
  alias Garrahan.Accounts
  alias Garrahan.Surgeries

  def create_surgery(%{assistants: _, patient_id: _, surgeon_id: _, diagnostic_id: _} = attrs) do
    attrs
    |> Enum.into(%{
      date: Date.utc_today()
    })
    |> Surgeries.create_surgery()
  end

  def create_user(attrs \\ %{}) do
    attrs
    |> Enum.into(%{password: "password", is_admin: false})
    |> Accounts.create_user()
  end

  def create_diagnostic(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      description: "a test diagnostic",
      name: "test_diagnostic"
    })
    |> Surgeries.create_diagnostic()
  end

  def create_patient(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      address: "some address",
      birthdate: ~D[2000-04-17],
      city: "some city",
      first_name: "test_first_name",
      last_name: "test_last_name",
      province: "BA"
    })
    |> Surgeries.create_patient()
  end

  def create_surgeon(attrs, user) do
    attrs
    |> Enum.into(%{
      email: "some@email.com",
      first_name: "test_first_name",
      last_name: "test_last_name",
      license: "test_license",
      user: user
    })
    |> Surgeries.create_surgeon()
  end

  def create_surgeon(attrs \\ %{}) do
    {:ok, user} = create_user()
    create_surgeon(attrs, user)
  end
end
