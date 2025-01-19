defmodule KanbanWeb.PageControllerTest do
  use KanbanWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "1.7.18"
  end
end
