defmodule GarrahanWeb.DiagnosticController do
  use GarrahanWeb, :controller

  alias Garrahan.Surgeries
  alias Garrahan.Surgeries.Diagnostic

  action_fallback GarrahanWeb.FallbackController

  def index(conn, _params) do
    diagnostics = Surgeries.list_diagnostics()
    render(conn, "index.json", diagnostics: diagnostics)
  end

  def create(conn, %{"diagnostic" => diagnostic_params}) do
    with {:ok, %Diagnostic{} = diagnostic} <- Surgeries.create_diagnostic(diagnostic_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.diagnostic_path(conn, :show, diagnostic))
      |> render("show.json", diagnostic: diagnostic)
    end
  end

  def show(conn, %{"id" => id}) do
    diagnostic = Surgeries.get_diagnostic!(id)
    render(conn, "show.json", diagnostic: diagnostic)
  end

  def update(conn, %{"id" => id, "diagnostic" => diagnostic_params}) do
    diagnostic = Surgeries.get_diagnostic!(id)

    with {:ok, %Diagnostic{} = diagnostic} <- Surgeries.update_diagnostic(diagnostic, diagnostic_params) do
      render(conn, "show.json", diagnostic: diagnostic)
    end
  end

  def delete(conn, %{"id" => id}) do
    diagnostic = Surgeries.get_diagnostic!(id)

    with {:ok, %Diagnostic{}} <- Surgeries.delete_diagnostic(diagnostic) do
      send_resp(conn, :no_content, "")
    end
  end
end
