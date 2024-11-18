defmodule TodoWeb.TaskLive.TaskComponent do
  use TodoWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-row">
      <div class="flex-none w-14"><input class="peer" type="checkbox" id="my-checkbox" /></div>
      <div class="flex-auto"><%= @task.title %></div>
    </div>
    """
  end
end
