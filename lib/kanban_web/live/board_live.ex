defmodule KanbanWeb.BoardLive do
  use KanbanWeb, :live_view

  def mount(_params, _session, socket) do
    tasks = get_initial_tasks()

    {:ok, assign(socket, tasks: tasks)}
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

  def render(assigns) do
    ~H"""
    <div class="board">
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
end
