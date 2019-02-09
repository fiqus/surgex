defmodule Garrahan.SurgeriesTest do
  use Garrahan.DataCase

  alias Garrahan.Surgeries
  alias Garrahan.Accounts

  describe "diagnostics" do
    alias Garrahan.Surgeries.Diagnostic

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def diagnostic_fixture(attrs \\ %{}) do
      {:ok, diagnostic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surgeries.create_diagnostic()

      diagnostic
    end

    test "list_diagnostics/0 returns all diagnostics" do
      diagnostic = diagnostic_fixture()
      assert Surgeries.list_diagnostics() == [diagnostic]
    end

    test "get_diagnostic!/1 returns the diagnostic with given id" do
      diagnostic = diagnostic_fixture()
      assert Surgeries.get_diagnostic!(diagnostic.id) == diagnostic
    end

    test "create_diagnostic/1 with valid data creates a diagnostic" do
      assert {:ok, %Diagnostic{} = diagnostic} = Surgeries.create_diagnostic(@valid_attrs)
      assert diagnostic.description == "some description"
      assert diagnostic.name == "some name"
    end

    test "create_diagnostic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surgeries.create_diagnostic(@invalid_attrs)
    end

    test "update_diagnostic/2 with valid data updates the diagnostic" do
      diagnostic = diagnostic_fixture()

      assert {:ok, %Diagnostic{} = diagnostic} =
               Surgeries.update_diagnostic(diagnostic, @update_attrs)

      assert diagnostic.description == "some updated description"
      assert diagnostic.name == "some updated name"
    end

    test "update_diagnostic/2 with invalid data returns error changeset" do
      diagnostic = diagnostic_fixture()
      assert {:error, %Ecto.Changeset{}} = Surgeries.update_diagnostic(diagnostic, @invalid_attrs)
      assert diagnostic == Surgeries.get_diagnostic!(diagnostic.id)
    end

    test "delete_diagnostic/1 deletes the diagnostic" do
      diagnostic = diagnostic_fixture()
      assert {:ok, %Diagnostic{}} = Surgeries.delete_diagnostic(diagnostic)
      assert_raise Ecto.NoResultsError, fn -> Surgeries.get_diagnostic!(diagnostic.id) end
    end

    test "change_diagnostic/1 returns a diagnostic changeset" do
      diagnostic = diagnostic_fixture()
      assert %Ecto.Changeset{} = Surgeries.change_diagnostic(diagnostic)
    end
  end

  describe "surgeons" do
    alias Garrahan.Surgeries.Surgeon

    @valid_attrs %{
      email: "some@email.com",
      first_name: "some first_name",
      last_name: "some last_name",
      license: "some license"
    }
    @update_attrs %{
      email: "updated@email.com",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      license: "some updated license"
    }
    @create_user_attrs %{password: "mypassword", is_admin: false}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, license: nil}

    def surgeon_fixture(attrs \\ %{}) do
      {:ok, user} = Accounts.create_user(@create_user_attrs)

      {:ok, surgeon} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surgeries.create_surgeon(user)

      %{surgeon | user: Map.put(surgeon.user, :password, nil)}
    end

    test "list_surgeons/0 returns all surgeons" do
      surgeon = surgeon_fixture()
      assert Surgeries.list_surgeons() == [surgeon]
    end

    test "get_surgeon!/1 returns the surgeon with given id" do
      surgeon = surgeon_fixture()
      surgeon_found = Surgeries.get_surgeon!(surgeon.id)
      assert surgeon_found.id == surgeon.id
    end

    test "create_surgeon/1 with valid data creates a surgeon without a user" do
      assert {:ok, %Surgeon{} = surgeon} = Surgeries.create_surgeon(@valid_attrs)
      assert surgeon.first_name == "some first_name"
      assert surgeon.last_name == "some last_name"
      assert surgeon.license == "some license"
      assert surgeon.user_id == nil
    end

    test "create_surgeon/2 with valid data creates a surgeon and a user (user has_one surgeon)" do
      {:ok, user} = Accounts.create_user(@create_user_attrs)
      assert {:ok, %Surgeon{} = surgeon} = Surgeries.create_surgeon(@valid_attrs, user)
      assert surgeon.first_name == "some first_name"
      assert surgeon.last_name == "some last_name"
      assert surgeon.license == "some license"
      assert user.id === surgeon.user.id
    end

    test "create_surgeon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surgeries.create_surgeon(@invalid_attrs)
    end

    test "update_surgeon/2 with valid data updates the surgeon" do
      surgeon = surgeon_fixture()
      assert {:ok, %Surgeon{} = surgeon} = Surgeries.update_surgeon(surgeon, @update_attrs)
      assert surgeon.first_name == "some updated first_name"
      assert surgeon.last_name == "some updated last_name"
      assert surgeon.license == "some updated license"
    end

    test "update_surgeon/2 with invalid data returns error changeset" do
      surgeon = surgeon_fixture()
      assert {:error, %Ecto.Changeset{}} = Surgeries.update_surgeon(surgeon, @invalid_attrs)
      assert surgeon == Surgeries.get_surgeon!(surgeon.id)
    end

    test "delete_surgeon/1 deletes the surgeon" do
      surgeon = surgeon_fixture()
      assert {:ok, %Surgeon{}} = Surgeries.delete_surgeon(surgeon)
      assert_raise Ecto.NoResultsError, fn -> Surgeries.get_surgeon!(surgeon.id) end
    end

    test "change_surgeon/1 returns a surgeon changeset" do
      surgeon = surgeon_fixture()
      assert %Ecto.Changeset{} = Surgeries.change_surgeon(surgeon)
    end
  end

  describe "patients" do
    alias Garrahan.Surgeries.Patient

    @valid_attrs %{
      address: "some address",
      birthdate: ~D[2010-04-17],
      city: "some city",
      first_name: "some first_name",
      last_name: "some last_name",
      province: "some province"
    }
    @update_attrs %{
      address: "some updated address",
      birthdate: ~D[2011-05-18],
      city: "some updated city",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      province: "some updated province"
    }
    @invalid_attrs %{
      address: nil,
      birthdate: nil,
      city: nil,
      first_name: nil,
      last_name: nil,
      province: nil
    }

    def patient_fixture(attrs \\ %{}) do
      {:ok, patient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surgeries.create_patient()

      patient
    end

    test "list_patients/0 returns all patients" do
      patient = patient_fixture()
      assert Surgeries.list_patients() == [patient]
    end

    test "get_patient!/1 returns the patient with given id" do
      patient = patient_fixture()
      assert Surgeries.get_patient!(patient.id) == patient
    end

    test "create_patient/1 with valid data creates a patient" do
      assert {:ok, %Patient{} = patient} = Surgeries.create_patient(@valid_attrs)
      assert patient.address == "some address"
      assert patient.birthdate == ~D[2010-04-17]
      assert patient.city == "some city"
      assert patient.first_name == "some first_name"
      assert patient.last_name == "some last_name"
      assert patient.province == "some province"
    end

    test "create_patient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surgeries.create_patient(@invalid_attrs)
    end

    test "update_patient/2 with valid data updates the patient" do
      patient = patient_fixture()
      assert {:ok, %Patient{} = patient} = Surgeries.update_patient(patient, @update_attrs)
      assert patient.address == "some updated address"
      assert patient.birthdate == ~D[2011-05-18]
      assert patient.city == "some updated city"
      assert patient.first_name == "some updated first_name"
      assert patient.last_name == "some updated last_name"
      assert patient.province == "some updated province"
    end

    test "update_patient/2 with invalid data returns error changeset" do
      patient = patient_fixture()
      assert {:error, %Ecto.Changeset{}} = Surgeries.update_patient(patient, @invalid_attrs)
      assert patient == Surgeries.get_patient!(patient.id)
    end

    test "delete_patient/1 deletes the patient" do
      patient = patient_fixture()
      assert {:ok, %Patient{}} = Surgeries.delete_patient(patient)
      assert_raise Ecto.NoResultsError, fn -> Surgeries.get_patient!(patient.id) end
    end

    test "change_patient/1 returns a patient changeset" do
      patient = patient_fixture()
      assert %Ecto.Changeset{} = Surgeries.change_patient(patient)
    end
  end

  describe "surgeries" do
    alias Garrahan.Surgeries.Surgery

    @valid_attrs %{date: ~D[2010-04-17]}
    @update_attrs %{date: ~D[2011-05-18]}
    @invalid_attrs %{date: nil}

    def surgery_fixture(attrs \\ %{}) do
      {:ok, surgery} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surgeries.create_surgery()

      surgery
    end

    test "list_surgeries/0 returns all surgeries" do
      surgery = surgery_fixture()
      assert Surgeries.list_surgeries() == [surgery]
    end

    test "get_surgery!/1 returns the surgery with given id" do
      surgery = surgery_fixture()
      assert Surgeries.get_surgery!(surgery.id) == surgery
    end

    test "create_surgery/1 with valid data creates a surgery" do
      assert {:ok, %Surgery{} = surgery} = Surgeries.create_surgery(@valid_attrs)
      assert surgery.date == ~D[2010-04-17]
    end

    test "create_surgery/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surgeries.create_surgery(@invalid_attrs)
    end

    test "update_surgery/2 with valid data updates the surgery" do
      surgery = surgery_fixture()
      assert {:ok, %Surgery{} = surgery} = Surgeries.update_surgery(surgery, @update_attrs)
      assert surgery.date == ~D[2011-05-18]
    end

    test "update_surgery/2 with invalid data returns error changeset" do
      surgery = surgery_fixture()
      assert {:error, %Ecto.Changeset{}} = Surgeries.update_surgery(surgery, @invalid_attrs)
      assert surgery == Surgeries.get_surgery!(surgery.id)
    end

    test "delete_surgery/1 deletes the surgery" do
      surgery = surgery_fixture()
      assert {:ok, %Surgery{}} = Surgeries.delete_surgery(surgery)
      assert_raise Ecto.NoResultsError, fn -> Surgeries.get_surgery!(surgery.id) end
    end

    test "change_surgery/1 returns a surgery changeset" do
      surgery = surgery_fixture()
      assert %Ecto.Changeset{} = Surgeries.change_surgery(surgery)
    end
  end
end
