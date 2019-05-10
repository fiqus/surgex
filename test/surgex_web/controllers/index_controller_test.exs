defmodule SurgexWeb.IndexControllerTest do
  use SurgexWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "<div id=\"app\"></div>"
  end
end
