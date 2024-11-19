defmodule Todo.Reminders.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Todo.Accounts.User

  schema "tasks" do
    field :complete, :boolean, default: false
    field :title, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> base_changeset(attrs)
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
  end

  def changeset(task, %User{} = user, attrs) do
    task
    |> base_changeset(attrs)
    |> put_assoc(:user, user)
    |> IO.inspect(label: "In user changeset")
  end

  defp base_changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :complete, :user_id])
    |> validate_required([:title])
    |> validate_inclusion(:complete, [true, false])
    |> validate_length(:title, max: 100)
  end
end
