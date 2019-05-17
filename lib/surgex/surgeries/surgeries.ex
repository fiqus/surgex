defmodule Surgex.Surgeries do
  @moduledoc """
  The Surgeries context.
  """

  import Ecto.Query, warn: false

  require Logger

  alias Surgex.Repo
  alias Surgex.Surgeries.Diagnostic

  @doc """
  Returns the list of diagnostics.

  ## Examples

      iex> list_diagnostics()
      [%Diagnostic{}, ...]

  """
  def list_diagnostics do
    Repo.all(from d in Diagnostic, order_by: [d.name])
  end

  @doc """
  Gets a single diagnostic.

  Raises `Ecto.NoResultsError` if the Diagnostic does not exist.

  ## Examples

      iex> get_diagnostic!(123)
      %Diagnostic{}

      iex> get_diagnostic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_diagnostic!(id), do: Repo.get!(Diagnostic, id)

  @doc """
  Creates a diagnostic.

  ## Examples

      iex> create_diagnostic(%{field: value})
      {:ok, %Diagnostic{}}

      iex> create_diagnostic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_diagnostic(attrs \\ %{}) do
    %Diagnostic{}
    |> Diagnostic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a diagnostic.

  ## Examples

      iex> update_diagnostic(diagnostic, %{field: new_value})
      {:ok, %Diagnostic{}}

      iex> update_diagnostic(diagnostic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_diagnostic(%Diagnostic{} = diagnostic, attrs) do
    diagnostic
    |> Diagnostic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Diagnostic.

  ## Examples

      iex> delete_diagnostic(diagnostic)
      {:ok, %Diagnostic{}}

      iex> delete_diagnostic(diagnostic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_diagnostic(%Diagnostic{} = diagnostic) do
    Repo.delete(diagnostic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking diagnostic changes.

  ## Examples

      iex> change_diagnostic(diagnostic)
      %Ecto.Changeset{source: %Diagnostic{}}

  """
  def change_diagnostic(%Diagnostic{} = diagnostic) do
    Diagnostic.changeset(diagnostic, %{})
  end

  alias Surgex.Surgeries.Surgeon

  @doc """
  Returns the list of surgeons.

  ## Examples

      iex> list_surgeons()
      [%Surgeon{}, ...]

  """
  def list_surgeons do
    Repo.all(from s in Surgeon, order_by: [s.last_name, s.first_name])
    |> preload_surgeon_user()
  end

  @doc """
  Gets a single surgeon.

  Raises `Ecto.NoResultsError` if the Surgeon does not exist.

  ## Examples

      iex> get_surgeon!(123)
      %Surgeon{}

      iex> get_surgeon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_surgeon!(id), do: Repo.get!(Surgeon, id) |> preload_surgeon_user()

  @doc """
  Gets a single surgeon by email.

  ## Examples

      iex> get_surgeon_by_email("some@email.com")
      %Surgeon{}

  """
  def get_surgeon_by_email(email) do
    query = from(s in Surgeon, where: s.email == ^email)

    Repo.one(query) |> preload_surgeon_user()
  end

  @doc """
  Gets a single surgeon by user_id.

  ## Examples

      iex> get_surgeon_by_email("some@email.com")
      %Surgeon{}

  """
  def get_surgeon_by_user_id(user_id) do
    query = from(s in Surgeon, where: s.user_id == ^user_id)

    Repo.one(query) |> preload_surgeon_user()
  end

  @doc """
  Creates a surgeon.

  ## Examples

      iex> create_surgeon(%{field: value})
      {:ok, %Surgeon{}}

      iex> create_surgeon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_surgeon(attrs \\ %{}) do
    %Surgeon{}
    |> Surgeon.changeset(attrs)
    |> Repo.insert()

    # |> preload_surgeon_user()
  end

  @doc """
  Creates a surgeon with a user associated.

  ## Examples

      iex> create_surgeon(%{field: value}, user)
      {:ok, %Surgeon{}}

      iex> create_surgeon(%{field: bad_value}, nil)
      {:error, %Ecto.Changeset{}}

  """
  def create_surgeon(attrs, user) do
    %Surgeon{}
    |> Surgeon.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()

    # |> preload_surgeon_user()
  end

  @doc """
  Updates a surgeon.

  ## Examples

      iex> update_surgeon(surgeon, %{field: new_value})
      {:ok, %Surgeon{}}

      iex> update_surgeon(surgeon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_surgeon(%Surgeon{} = surgeon, attrs) do
    surgeon
    |> Surgeon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Surgeon.

  ## Examples

      iex> delete_surgeon(surgeon)
      {:ok, %Surgeon{}}

      iex> delete_surgeon(surgeon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_surgeon(%Surgeon{} = surgeon) do
    # @TODO Remove this manual user delete!
    with {:ok, %Surgeon{}} <- Repo.delete(surgeon) do
      Surgex.Accounts.delete_user(surgeon.user)
      {:ok, %Surgeon{}}
    else
      err ->
        err
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking surgeon changes.

  ## Examples

      iex> change_surgeon(surgeon)
      %Ecto.Changeset{source: %Surgeon{}}

  """
  def change_surgeon(%Surgeon{} = surgeon) do
    Surgeon.changeset(surgeon, %{})
  end

  @doc """
  Preloads user into surgeon

  ## Examples

      iex> preload_surgeon_user(surgeon)
      %User{}

      iex> preload_surgeon_user({:ok, surgeon})
      {:ok, %User{}}

  """
  def preload_surgeon_user({:ok, surgeon}), do: {:ok, preload_surgeon_user(surgeon)}
  def preload_surgeon_user({:error, error}), do: {:error, error}
  def preload_surgeon_user(surgeon), do: Repo.preload(surgeon, :user)

  alias Surgex.Surgeries.Patient

  @doc """
  Returns the list of patients.

  ## Examples

      iex> list_patients()
      [%Patient{}, ...]

  """
  def list_patients do
    Repo.all(from p in Patient, order_by: [p.last_name, p.first_name])
  end

  @doc """
  Gets a single patient.

  Raises `Ecto.NoResultsError` if the Patient does not exist.

  ## Examples

      iex> get_patient!(123)
      %Patient{}

      iex> get_patient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_patient!(id), do: Repo.get!(Patient, id)

  @doc """
  Creates a patient.

  ## Examples

      iex> create_patient(%{field: value})
      {:ok, %Patient{}}

      iex> create_patient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_patient(attrs \\ %{}) do
    %Patient{}
    |> Patient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a patient.

  ## Examples

      iex> update_patient(patient, %{field: new_value})
      {:ok, %Patient{}}

      iex> update_patient(patient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_patient(%Patient{} = patient, attrs) do
    patient
    |> Patient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Patient.

  ## Examples

      iex> delete_patient(patient)
      {:ok, %Patient{}}

      iex> delete_patient(patient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_patient(%Patient{} = patient) do
    Repo.delete(patient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking patient changes.

  ## Examples

      iex> change_patient(patient)
      %Ecto.Changeset{source: %Patient{}}

  """
  def change_patient(%Patient{} = patient) do
    Patient.changeset(patient, %{})
  end

  alias Surgex.Surgeries.Surgery

  @doc """
  Returns the list of surgeries.

  ## Examples

      iex> list_surgeries()
      [%Surgery{}, ...]

  """
  def list_surgeries do
    Repo.all(from s in Surgery, order_by: [desc: s.date])
    |> preload_surgery_associations()
  end

  @doc """
  Returns the list of surgeries for given surgeon.

  ## Examples

      iex> list_surgeries(%Surgeon{})
      [%Surgery{}, ...]

  """
  def list_surgeries(%Surgeon{id: surgeon_id}) do
    query = from(s in Surgery, where: s.surgeon_id == ^surgeon_id, order_by: [desc: s.date])

    Repo.all(query)
    |> preload_surgery_associations()
  end

  @doc """
  Gets a single surgery.

  Raises `Ecto.NoResultsError` if the Surgery does not exist.

  ## Examples

      iex> get_surgery!(123)
      %Surgery{}

      iex> get_surgery!(456)
      ** (Ecto.NoResultsError)

  """
  def get_surgery!(id) do
    Repo.get!(Surgery, id)
    |> preload_surgery_associations()
  end

  def preload_surgery_associations(surgery_or_surgeries) do
    surgery_or_surgeries
    |> Repo.preload(:surgeon)
    |> Repo.preload(:assistants)
    |> Repo.preload(:diagnostic)
    |> Repo.preload(:patient)
    |> Repo.preload(:photos)
  end

  @doc """
  Creates a surgery.

  ## Examples

      iex> create_surgery(%{field: value})
      {:ok, %Surgery{}}

      iex> create_surgery(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_surgery(attrs \\ %{}) do
    %Surgery{}
    |> Surgery.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a surgery.

  ## Examples

      iex> update_surgery(surgery, %{field: new_value})
      {:ok, %Surgery{}}

      iex> update_surgery(surgery, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_surgery(%Surgery{} = surgery, attrs) do
    surgery
    |> Surgery.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Surgery.

  ## Examples

      iex> delete_surgery!(surgery)
      {:ok, %Surgery{}}

      iex> delete_surgery!(surgery)
      {:error, %Ecto.Changeset{}}

  """
  def delete_surgery!(%Surgery{} = surgery) do
    try do
      Repo.preload(surgery, :photos).photos
      |> Enum.each(&Surgery.delete_photo_file!/1)

      Repo.delete(surgery)
    rescue
      error ->
        Logger.error("Error at Surgeries.delete_surgery!/1: #{inspect(error)}")
        reraise error, __STACKTRACE__
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking surgery changes.

  ## Examples

      iex> change_surgery(surgery)
      %Ecto.Changeset{source: %Surgery{}}

  """
  def change_surgery(%Surgery{} = surgery) do
    Surgery.changeset(surgery, %{})
  end
end
