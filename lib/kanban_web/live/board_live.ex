defmodule KanbanWeb.BoardLive do
  use KanbanWeb, :live_view

  alias KanbanWeb.TaskFormComponent

  def mount(_params, _session, socket) do
    tasks = get_initial_tasks()
    {todo_tasks, in_progress_tasks, done_tasks} = sort_tasks_by_status(tasks)

    {:ok,
     assign(socket,
       todo_tasks: todo_tasks,
       in_progress_tasks: in_progress_tasks,
       done_tasks: done_tasks
     )}
  end

  def handle_info({:new_task, task_params}, socket) do
    new_task = %{
      id: length(socket.assigns.todo_tasks) + 1,
      title: task_params.title,
      content: task_params.content,
      status: "todo"
    }

    updated_todo_tasks = [new_task | socket.assigns.todo_tasks]
    {:noreply, assign(socket, todo_tasks: updated_todo_tasks)}
  end

  def handle_event("reposition", params, socket) do
    %{
      "id" => task_id,
      "from" => %{"list_id" => from_column},
      "to" => %{"list_id" => to_column},
      "new" => new_position
    } = params

    task_id = String.to_integer(task_id)

    # Get the current lists
    from_list = get_list_by_column_id(socket, from_column)
    to_list = get_list_by_column_id(socket, to_column)

    # Find and update the task
    task = Enum.find(from_list, &(&1.id == task_id))
    updated_task = %{task | status: column_id_to_status(to_column)}

    # Remove task from the source list
    updated_from_list = Enum.reject(from_list, &(&1.id == task_id))

    # Insert task into the destination list at the new position
    updated_to_list =
      if from_column == to_column do
        List.insert_at(updated_from_list, new_position, updated_task)
      else
        List.insert_at(to_list, new_position, updated_task)
      end

    # Update the socket assigns
    updated_socket =
      socket
      |> update_list_in_socket(from_column, updated_from_list)
      |> update_list_in_socket(to_column, updated_to_list)

    {:noreply, updated_socket}
  end

  defp get_list_by_column_id(socket, column_id) do
    case column_id do
      "todo-column" -> socket.assigns.todo_tasks
      "in-progress-column" -> socket.assigns.in_progress_tasks
      "done-column" -> socket.assigns.done_tasks
    end
  end

  defp update_list_in_socket(socket, column_id, updated_list) do
    case column_id do
      "todo-column" -> assign(socket, :todo_tasks, updated_list)
      "in-progress-column" -> assign(socket, :in_progress_tasks, updated_list)
      "done-column" -> assign(socket, :done_tasks, updated_list)
    end
  end

  defp column_id_to_status(column_id) do
    case column_id do
      "todo-column" -> "todo"
      "in-progress-column" -> "in_progress"
      "done-column" -> "done"
    end
  end

  defp sort_tasks_by_status(tasks) do
    todo_tasks = Enum.filter(tasks, &(&1.status == "todo"))
    in_progress_tasks = Enum.filter(tasks, &(&1.status == "in_progress"))
    done_tasks = Enum.filter(tasks, &(&1.status == "done"))

    {todo_tasks, in_progress_tasks, done_tasks}
  end

  defp get_initial_tasks() do
    [
      %{id: 1, title: "Design UI1", content: "Create wireframes", status: "todo"},
      %{id: 2, title: "Design UI2", content: "Create wireframes", status: "todo"},
      %{id: 3, title: "Design UI3", content: "Create wireframes", status: "todo"},
      %{
        id: 223,
        title: "Implement backend",
        content: "Set up Phoenix project",
        status: "in_progress"
      },
      %{id: 123, title: "Write tests", content: "Create unit tests", status: "done"}
    ]
  end

  def render(assigns) do
    ~H"""
    <div class="board">
      <.live_component module={TaskFormComponent} id="new-task-form" />
      <div class="column-container">
        <div class="column">
          <h2>Todo</h2>
          <div
            id="todo-column"
            class="task-list"
            phx-hook="Sortable"
            data-list_id="todo-column"
            data-group="kanban"
          >
            <%= for task <- @todo_tasks do %>
              <div
                class="task drag-item:focus-within:ring-0 drag-item:focus-within:ring-offset-0 drag-ghost:bg-zinc-300 drag-ghost:border-0 drag-ghost:ring-0"
                id={"task-#{task.id}"}
                data-id={task.id}
              >
                <h3><%= task.title %></h3>
                <p><%= task.content %></p>
              </div>
            <% end %>
          </div>
        </div>
      </div>
      <div class="column-container">
        <div class="column">
          <h2>In Progress</h2>
          <div
            id="in-progress-column"
            class="task-list"
            phx-hook="Sortable"
            data-list_id="in-progress-column"
            data-group="kanban"
          >
            <%= for task <- @in_progress_tasks do %>
              <div
                class="task drag-item:focus-within:ring-0 drag-item:focus-within:ring-offset-0 drag-ghost:bg-zinc-300 drag-ghost:border-0 drag-ghost:ring-0"
                id={"task-#{task.id}"}
                data-id={task.id}
              >
                <h3><%= task.title %></h3>
                <p><%= task.content %></p>
              </div>
            <% end %>
          </div>
        </div>
      </div>
      <div class="column-container">
        <div class="column">
          <h2>Done</h2>
          <div
            id="done-column"
            class="task-list"
            phx-hook="Sortable"
            data-list_id="done-column"
            data-group="kanban"
          >
            <%= for task <- @done_tasks do %>
              <div
                class="task drag-item:focus-within:ring-0 drag-item:focus-within:ring-offset-0 drag-ghost:bg-zinc-300 drag-ghost:border-0 drag-ghost:ring-0"
                id={"task-#{task.id}"}
                data-id={task.id}
              >
                <h3><%= task.title %></h3>
                <p><%= task.content %></p>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
