defmodule CapsensQonto.App do
  use Ecto.Schema
  import Ecto.Changeset

  alias CapsensQonto.App
  alias CapsensQonto.Repo

  schema "apps" do
    field :iban, :string
    field :identifier, :string
    field :secret_key, :string
    field :transaction_type, {:array, :string}
    field :slack_access_token, :string
    field :slack_user_id, :string
    field :slack_hook_url, :string

    timestamps()
  end

  def changeset(app, attrs \\ %{}) do
    app
    |> cast(attrs, [:identifier, :secret_key, :iban, :transaction_type, :slack_access_token, :slack_user_id])
    |> validate_required([:slack_access_token, :slack_user_id])
    |> unique_constraint(:slack_user_id)
  end

  def create(attrs \\ %{}) do
    %App{}
    |> App.changeset(attrs)
    |> Repo.insert()
  end

  def transaction_types do
    ["Crédit", "Débit"]
  end

  def list do
    Repo.all(App)
  end

  def get!(id) do
    Repo.get!(App, id)
  end

  def change(%App{} = app) do
    App.changeset(app, %{})
  end

  def update(%App{} = app, attrs) do
    app
    |> App.changeset(attrs)
    |> Repo.update()
  end
end
