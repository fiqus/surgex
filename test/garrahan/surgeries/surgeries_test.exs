defmodule Garrahan.SurgeriesTest do
  use Garrahan.DataCase

  alias Garrahan.Surgeries

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
      assert {:ok, %Diagnostic{} = diagnostic} = Surgeries.update_diagnostic(diagnostic, @update_attrs)
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
end
