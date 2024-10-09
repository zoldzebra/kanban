defmodule KanbanWeb.BoardLive do
  use KanbanWeb, :live_view

  alias KanbanWeb.TaskFormComponent

  def mount(_params, _session, socket) do
    tasks = get_initial_tasks()
    {:ok, assign(socket, tasks: tasks)}
  end

  def handle_info({:new_task, task_params}, socket) do
    new_task = %{
      id: length(socket.assigns.tasks) + 1,
      title: task_params.title,
      content: task_params.content,
      status: "todo"
    }

    updated_tasks = [new_task | socket.assigns.tasks]
    {:noreply, assign(socket, tasks: updated_tasks)}
  end

  def render(assigns) do
    ~H"""
    <div class="board">
      <.live_component module={TaskFormComponent} id="new-task-form" />
      <div id="todo-column" class="column">
        <h2>Todo</h2>
        <%= for task <- Enum.filter(@tasks, & &1.status == "todo") do %>
          <div class="task" id={"task-#{task.id}"}>
            <h3><%= task.title %></h3>
            <p><%= task.content %></p>
          </div>
        <% end %>
      </div>
      <div id="in-progress-column" class="column">
        <h2>In Progress</h2>
        <%= for task <- Enum.filter(@tasks, & &1.status == "in_progress") do %>
          <div class="task" id={"task-#{task.id}"}>
            <h3><%= task.title %></h3>
            <p><%= task.content %></p>
          </div>
        <% end %>
      </div>
      <div id="done-column" class="column">
        <h2>Done</h2>
        <%= for task <- Enum.filter(@tasks, & &1.status == "done") do %>
          <div class="task" id={"task-#{task.id}"}>
            <h3><%= task.title %></h3>
            <p><%= task.content %></p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def get_initial_tasks() do
    [
      %{id: 1, title: "Design UI", content: "Create wireframes", status: "todo"},
      %{
        id: 2,
        title: "Implement backend",
        content: "Set up Phoenix project",
        status: "in_progress"
      },
      %{id: 3, title: "Write tests", content: "Create unit tests", status: "done"}
    ]
  end
end
