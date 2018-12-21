defmodule Garrahan.Surgeries do
  @moduledoc """
  The Surgeries context.
  """

  import Ecto.Query, warn: false
  alias Garrahan.Repo

  alias Garrahan.Surgeries.Diagnostic

  @doc """
  Returns the list of diagnostics.

  ## Examples

      iex> list_diagnostics()
      [%Diagnostic{}, ...]

  """
  def list_diagnostics do
    Repo.all(Diagnostic)
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
end
