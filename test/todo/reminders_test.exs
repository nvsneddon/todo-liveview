defmodule Todo.RemindersTest do
  use Todo.DataCase

  alias Todo.Reminders

  describe "tasks" do
    alias Todo.Reminders.Task

    import Todo.RemindersFixtures

    @invalid_attrs %{complete: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Reminders.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Reminders.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{complete: true, title: "some title"}

      assert {:ok, %Task{} = task} = Reminders.create_task(valid_attrs)
      assert task.complete == true
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reminders.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{complete: false, title: "some updated title"}

      assert {:ok, %Task{} = task} = Reminders.update_task(task, update_attrs)
      assert task.complete == false
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Reminders.update_task(task, @invalid_attrs)
      assert task == Reminders.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Reminders.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Reminders.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Reminders.change_task(task)
    end
  end
end
