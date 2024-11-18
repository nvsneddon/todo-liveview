defmodule TodoWeb.TaskLive.Index do
  use TodoWeb, :live_view

  alias Todo.Reminders
  alias Todo.Reminders.Task

  import TodoWeb.TaskLive.TaskComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tasks, Reminders.list_tasks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Reminders.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({TodoWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Reminders.get_task!(id)
    {:ok, _} = Reminders.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete-all", _params, socket) do
    {_, deleted_tasks} = Reminders.delete_completed()
    socket =
      Enum.reduce(deleted_tasks, socket, fn task, acc_socket ->
        stream_delete(acc_socket, :tasks, task)
      end)
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    task = Reminders.get_task!(id)
    {:ok, updated_task} = Reminders.update_task(task, %{complete: !task.complete})

    {:noreply, stream_insert(socket, :tasks, updated_task)}
  end
end
