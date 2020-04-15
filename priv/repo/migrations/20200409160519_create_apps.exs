defmodule CapsensQonto.Repo.Migrations.CreateApps do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :qonto_identifier, :string
      add :qonto_secret_key, :string
      add :qonto_iban, :string
      add :qonto_transaction_type, {:array, :string}
      add :slack_channel, :string

      timestamps()
    end
  end
end
