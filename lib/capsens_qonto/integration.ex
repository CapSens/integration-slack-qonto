defmodule CapsensQonto.Integration do
  use Ecto.Schema
  import Ecto.Changeset

  alias CapsensQonto.Integration
  alias CapsensQonto.Repo

  schema "integrations" do
    field :qonto_iban, :string
    field :qonto_identifier, :string
    field :qonto_secret_key, :string
    field :qonto_transaction_type, {:array, :string}
    field :slack_channel, :string

    timestamps()
  end

  def changeset(integration, attrs \\ %{}) do
    integration
    |> cast(attrs, [:qonto_iban, :qonto_identifier, :qonto_secret_key, :qonto_transaction_type, :slack_channel])
    |> validate_required([:qonto_iban, :qonto_identifier, :qonto_secret_key, :qonto_transaction_type, :slack_channel])
  end

  def create(attrs \\ %{}) do
    %Integration{}
    |> Integration.changeset(attrs)
    |> Repo.insert()
  end

  def qonto_transaction_types do
    ["Crédit", "Débit"]
  end

  def list do
    Repo.all(Integration)
  end

  def get!(id) do
    Repo.get!(Integration, id)
  end

  def update(changeset) do
    Repo.update(changeset)
  end
end
