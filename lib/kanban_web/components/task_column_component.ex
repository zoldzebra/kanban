defmodule KanbanWeb.TaskColumnComponent do
  use KanbanWeb, :live_component

  def handle_event(event, params, socket) do
    send(self(), {event, params})
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="column" id={@id}>
      <h2><%= @title %></h2>
      <div id={@id} class="task-list" phx-hook="Sortable" data-list_id={@id} data-group="kanban">
        <%= for task <- @tasks do %>
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
    """
  end
end
