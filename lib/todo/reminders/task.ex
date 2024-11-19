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
  def changeset(task, attrs, user \\ nil) do
    task
    |> cast(attrs, [:title, :complete, :user_id])
    |> validate_required([:title])
    |> validate_inclusion(:complete, [true, false])
    |> validate_length(:title, max: 100)
    |> validate_user_assoc(user)
  end

  defp validate_user_assoc(changeset, nil) do
    changeset
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
  end

  defp validate_user_assoc(changeset, %User{} = user) do
    changeset
    |> put_assoc(:user, user)
  end
end
