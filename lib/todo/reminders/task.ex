defmodule Todo.Reminders.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :complete, :boolean, default: false
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :complete])
    |> validate_required([:title])
    |> validate_length(:title, max: 100)
  end
end
