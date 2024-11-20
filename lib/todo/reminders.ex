defmodule Todo.Reminders do
  @moduledoc """
  The Reminders context.
  """

  import Ecto.Query, warn: false
  alias Todo.Accounts.User
  alias Todo.Repo

  alias Todo.Reminders.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks(%User{} = user) do
    query = from t in Task, where: t.user_id == ^user.id, order_by: t.id
    Repo.all(query)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}, user \\ nil) do
    %Task{}
    |> Task.changeset(attrs, user)
    |> Repo.insert()
    |> broadcast(:task_created)
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
    |> broadcast(:task_updated)
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    task
    |> Repo.delete()
    |> broadcast(:task_deleted)
  end

  @doc """
  Deletes all tasks that are completed and returns all deleted tasks

  ## Examples

      iex> delete_completed(task)
      {:ok, [%Task{}]}

  """
  def delete_completed(%User{id: user_id}) do
    from(t in Task, where: t.complete, where: t.user_id == ^user_id, select: t)
    |> Repo.delete_all()
    |> broadcast(:completed_tasks_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def subscribe(%User{id: user_id}) do
    Phoenix.PubSub.subscribe(Todo.PubSub, "tasks" <> to_string(user_id))
  end

  def subscribe(user_id) when is_integer(user_id) do
    Phoenix.PubSub.subscribe(Todo.PubSub, "tasks" <> to_string(user_id))
  end

  defp broadcast({:error, _} = error, _event), do: error

  defp broadcast({num, tasks}, :completed_tasks_deleted) when is_integer(num) do
    Phoenix.PubSub.broadcast(
      Todo.PubSub,
      "tasks" <> to_string(hd(tasks).user_id),
      {:completed_tasks_deleted, tasks}
    )

    {:ok, tasks}
  end

  defp broadcast({:ok, task}, event) do
    Phoenix.PubSub.broadcast(Todo.PubSub, "tasks" <> to_string(task.user_id), {event, task})
    {:ok, task}
  end
end
