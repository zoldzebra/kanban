defmodule KanbanWeb.BoardLiveTest do
  use KanbanWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    for expected_text <- ["Todo", "In Progress", "Done"] do
      assert disconnected_html =~ expected_text
      assert render(page_live) =~ expected_text
    end
  end

  test "renders all three columns", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")
    assert has_element?(page_live, "#todo-column")
    assert has_element?(page_live, "#in-progress-column")
    assert has_element?(page_live, "#done-column")
  end

  test "displays tasks in their respective columns", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    assert has_element?(page_live, "#todo-column", "Design UI")
    assert has_element?(page_live, "#in-progress-column", "Implement backend")
    assert has_element?(page_live, "#done-column", "Write tests")
  end
end
