defmodule CapsensQonto.App do
  use Ecto.Schema
  import Ecto.Changeset

  alias CapsensQonto.App
  alias CapsensQonto.Repo

  schema "apps" do
    field :qonto_iban, :string
    field :qonto_identifier, :string
    field :qonto_secret_key, :string
    field :qonto_transaction_type, {:array, :string}
    field :slack_access_token, :string
    field :slack_user_id, :string
    field :slack_hook_url, :string

    timestamps()
  end

  def changeset(app, attrs \\ %{}) do
    app
    |> cast(attrs, [:slack_access_token, :slack_user_id, :slack_hook_url])
    |> validate_required([:slack_access_token, :slack_user_id])
    |> unique_constraint(:slack_user_id)
  end

  def qonto_changeset(app, attrs \\ %{}) do
    app
    |> cast(attrs, [:qonto_identifier, :qonto_secret_key, :qonto_iban, :qonto_transaction_type])
    |> validate_required([:qonto_identifier, :qonto_secret_key, :qonto_iban, :qonto_transaction_type])
    |> validate_subset(:qonto_transaction_type, App.qonto_transaction_types)
  end

  def create(attrs \\ %{}) do
    %App{}
    |> App.changeset(attrs)
    |> Repo.insert()
  end

  def qonto_transaction_types do
    ["Crédit", "Débit"]
  end

  def list do
    Repo.all(App)
  end

  def get!(id) do
    Repo.get!(App, id)
  end

  def update(changeset) do
    Repo.update(changeset)
  end
end
