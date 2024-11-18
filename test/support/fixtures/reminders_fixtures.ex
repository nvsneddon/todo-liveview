defmodule Todo.RemindersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Reminders` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        complete: true,
        title: "some title"
      })
      |> Todo.Reminders.create_task()

    task
  end
end
