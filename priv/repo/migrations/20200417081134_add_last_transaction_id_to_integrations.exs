defmodule CapsensQonto.Repo.Migrations.AddLastTransactionIdToIntegrations do
  use Ecto.Migration

  def change do
    alter table(:integrations) do
      add :last_transaction_id, :string
    end
  end
end
