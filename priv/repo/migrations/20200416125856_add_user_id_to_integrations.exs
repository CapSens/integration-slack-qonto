defmodule CapsensQonto.Repo.Migrations.AddUserIdToIntegrations do
  use Ecto.Migration

  def change do
    alter table(:integrations) do
      add :user_id, references(:users)
    end
  end
end
