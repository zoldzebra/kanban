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

  test "can add a new task", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("form")
    |> render_submit(%{title: "New Task", content: "This is a new task"})

    updated_html = render(view)

    assert updated_html =~ "New Task"

    assert has_element?(view, "#todo-column", "New Task")
    assert has_element?(view, "#todo-column", "This is a new task")
  end

  test "can drag and drop a task within its own column", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    todo_column = view |> element("#todo-column") |> render()

    [first_task | _] =
      todo_column
      |> Floki.parse_fragment!()
      |> Floki.find(".task")
      |> Enum.map(&Floki.text/1)

    assert first_task =~ "Design UI1"

    # Simulate drag and drop within the todo column
    view
    |> element("#todo-column")
    |> render_hook("reposition", %{
      "id" => "1",
      "from" => %{"list_id" => "todo-column"},
      "to" => %{"list_id" => "todo-column"},
      "new" => 1
    })

    # Check if the task has moved to the new position
    todo_column = view |> element("#todo-column") |> render()

    [first_task, second_task | _] =
      todo_column
      |> Floki.parse_fragment!()
      |> Floki.find(".task")
      |> Enum.map(&Floki.text/1)

    assert first_task =~ "Design UI2"
    assert second_task =~ "Design UI1"
  end

  test "can drag and drop a task between columns", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    todo_column = view |> element("#todo-column") |> render()

    [first_task | _] =
      todo_column
      |> Floki.parse_fragment!()
      |> Floki.find(".task")
      |> Enum.map(&Floki.text/1)

    assert first_task =~ "Design UI1"

    # Simulate drag and drop within the todo column
    view
    |> element("#todo-column")
    |> render_hook("reposition", %{
      "id" => "1",
      "from" => %{"list_id" => "todo-column"},
      "to" => %{"list_id" => "done-column"},
      "new" => 1
    })

    # Check if the task has moved to the new position
    todo_column = view |> element("#todo-column") |> render()
    done_column = view |> element("#done-column") |> render()

    todo_tasks =
      todo_column
      |> Floki.parse_fragment!()
      |> Floki.find(".task")

    assert length(todo_tasks) == 2

    [_, second_task] =
      done_column
      |> Floki.parse_fragment!()
      |> Floki.find(".task")
      |> Enum.map(&Floki.text/1)

    assert second_task =~ "Design UI1"
  end
end
