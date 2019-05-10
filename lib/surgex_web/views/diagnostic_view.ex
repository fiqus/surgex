defmodule SurgexWeb.DiagnosticView do
  use SurgexWeb, :view
  alias SurgexWeb.DiagnosticView

  def render("index.json", %{diagnostics: diagnostics}) do
    %{data: render_many(diagnostics, DiagnosticView, "diagnostic.json")}
  end

  def render("show.json", %{diagnostic: diagnostic}) do
    %{data: render_one(diagnostic, DiagnosticView, "diagnostic.json")}
  end

  def render("diagnostic.json", %{diagnostic: diagnostic}) do
    %{id: diagnostic.id, name: diagnostic.name, description: diagnostic.description}
  end
end
