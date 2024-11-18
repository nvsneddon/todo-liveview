defmodule TodoWeb.TaskLive.TaskComponent do
  use Phoenix.Component

  def task(assigns) do
    ~H"""
    <div class="flex items-center space-x-4 m-6">
      <!-- Checkbox -->
      <div>
        <input
          id={"checkbox-#{@task.id}"}
          type="checkbox"
          class="hidden peer"
          checked={@task.complete}
          phx-click="toggle"
          phx-value-id={@task.id}
        />
        <label
          for={"checkbox-#{@task.id}"}
          class="w-6 h-6 flex items-center justify-center border-2 border-gray-300 rounded-lg cursor-pointer peer-checked:bg-blue-500 peer-checked:border-blue-500 hover:border-blue-400 focus:ring-2 focus:ring-blue-300 focus:outline-none"
        >
          <%!-- <.icon name="hero-check" class="h-3 w-3" /> --%>
        </label>
      </div>

      <!-- Title -->
      <span class="text-gray-700"><%= @task.title %></span>
    </div>
    """
  end
end
