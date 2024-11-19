defmodule Todo.RemindersTest do
  use Todo.DataCase

  alias Todo.Reminders

  describe "tasks" do
    alias Todo.Reminders.Task
    import Todo.RemindersFixtures

    @invalid_attrs %{complete: nil, title: nil}

    setup do
      import Todo.AccountsFixtures

      user = user_fixture()
      task = task_fixture(%{user: user})
      {:ok, task: task, user: user}
    end

    test "list_tasks/0 returns all tasks", %{task: task, user: user} do
      assert Reminders.list_tasks(user) == [task]
    end

    test "get_task!/1 returns the task with given id", %{task: task} do
      assert Reminders.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task", %{user: user} do
      valid_attrs = %{complete: false, title: "some title", user_id: user.id}

      assert {:ok, %Task{} = task} = Reminders.create_task(valid_attrs)
      assert task.complete == false
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reminders.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task", %{task: task} do
      update_attrs = %{complete: false, title: "some updated title"}

      assert {:ok, %Task{} = task} = Reminders.update_task(task, update_attrs)
      assert task.complete == false
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset", %{task: task} do
      assert {:error, %Ecto.Changeset{}} = Reminders.update_task(task, @invalid_attrs)
      assert task == Reminders.get_task!(task.id)
    end

    test "delete_task/1 deletes the task", %{task: task} do
      assert {:ok, %Task{}} = Reminders.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Reminders.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset", %{task: task} do
      assert %Ecto.Changeset{} = Reminders.change_task(task)
    end

    test "delete_completed/0 deletes all completed tasks", %{user: user} do
      incomplete_task = task_fixture(%{user: user, complete: false})
      task_fixture(%{user: user, complete: true})

      Reminders.delete_completed(user)

      assert Reminders.list_tasks(user) == [incomplete_task]
    end
  end
end
