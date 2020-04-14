defmodule CapsensQonto.Repo.Migrations.CreateApps do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :qonto_identifier, :string
      add :qonto_secret_key, :string
      add :qonto_iban, :string
      add :qonto_transaction_type, {:array, :string}
      add :slack_access_token, :string
      add :slack_user_id, :string, unique: true
      add :slack_hook_url, :string

      timestamps()
    end

    create unique_index(:apps, :slack_user_id)
  end
end
