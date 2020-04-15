defmodule CapsensQonto.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias CapsensQonto.User
  alias CapsensQonto.Repo

  schema "users" do
    field :slack_access_token, :string
    field :slack_user_id, :string

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:slack_access_token, :slack_user_id])
    |> validate_required([:slack_access_token, :slack_user_id])
    |> unique_constraint(:slack_user_id)
  end

  def create(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def list do
    Repo.all(User)
  end

  def get!(id) do
    Repo.get!(User, id)
  end

  def find_by(attrs) do
    Repo.get_by(User, attrs)
  end

  def update(changeset) do
    Repo.update(changeset)
  end
end
