defmodule Todo.RemindersFixtures do
  import Todo.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Reminders` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    user = Map.get(attrs, :user, user_fixture())
    
    attrs = Enum.into(attrs, %{
      complete: true,
      title: "some title",
      user_id: user.id
    })
    {:ok, task} =Todo.Reminders.create_task(attrs)

    task
  end
end
