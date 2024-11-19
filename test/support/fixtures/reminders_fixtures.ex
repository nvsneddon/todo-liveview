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
    user = user_fixture()

    {:ok, task} =
      attrs
      |> Enum.into(%{
        complete: true,
        title: "some title",
        user_id: user.id
      })
      |> Todo.Reminders.create_task()

    task
  end
end
