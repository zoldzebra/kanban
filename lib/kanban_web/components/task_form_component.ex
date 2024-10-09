defmodule KanbanWeb.TaskFormComponent do
  use KanbanWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="new-task-form">
      <.form for={@form} phx-submit="save" phx-target={@myself} phx-change="change">
        <.input type="text" field={@form[:title]} placeholder="Task Title" required />
        <.input type="text" field={@form[:content]} placeholder="Task Content" required />
        <.button type="submit">Add Task</.button>
      </.form>
    </div>
    """
  end

  def update(_assigns, socket) do
    {:ok, assign(socket, form: to_form(%{"title" => "", "content" => ""}))}
  end

  def handle_event("change", %{"title" => title, "content" => content}, socket) do
    {:noreply, assign(socket, form: to_form(%{"title" => title, "content" => content}))}
  end

  def handle_event("save", %{"title" => title, "content" => content}, socket) do
    send(self(), {:new_task, %{title: title, content: content}})
    {:noreply, assign(socket, form: to_form(%{"title" => "", "content" => ""}))}
  end
end
