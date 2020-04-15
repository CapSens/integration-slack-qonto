defmodule CapsensQonto.Repo.Migrations.CreateIntegrations do
  use Ecto.Migration

  def change do
    create table(:integrations) do
      add :qonto_identifier, :string
      add :qonto_secret_key, :string
      add :qonto_iban, :string
      add :qonto_transaction_type, {:array, :string}
      add :slack_channel, :string

      timestamps()
    end
  end
end
