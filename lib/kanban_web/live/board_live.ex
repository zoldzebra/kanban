# lib/kanban_web/live/board_live.ex
defmodule KanbanWeb.BoardLive do
  use KanbanWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="board">
      <div class="column">
        <h2>Todo</h2>
        <!-- Todo tasks will go here -->
      </div>
      <div class="column">
        <h2>In Progress</h2>
        <!-- In Progress tasks will go here -->
      </div>
      <div class="column">
        <h2>Done</h2>
        <!-- Done tasks will go here -->
      </div>
    </div>
    """
  end
end
