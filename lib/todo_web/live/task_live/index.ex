defmodule TodoWeb.TaskLive.Index do
  use TodoWeb, :live_view

  alias Todo.Reminders
  alias Todo.Reminders.Task

  import TodoWeb.TaskLive.TaskComponent

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns, label: "Mounting the socket")
    stream = stream(socket, :tasks, Reminders.list_tasks())

    IO.inspect(stream, label: "This is the stream")
    {:ok, stream}
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect(socket.assigns, label: "Handling Parameters")

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
    IO.inspect(socket.assigns, label: "Saved from form")

    {:noreply, stream_insert(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    IO.inspect(socket.assigns, label: "Delete event")

    task = Reminders.get_task!(id)
    {:ok, _} = Reminders.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    IO.inspect(socket.assigns, label: "Toggle event")

    task = Reminders.get_task!(id)
    {:ok, _} = Reminders.update_task(task, %{complete: !task.complete})

    {:noreply, socket}
  end
end
