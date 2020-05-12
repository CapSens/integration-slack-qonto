defmodule CapsensQonto.Repo.Migrations.AddSlackChannelNameToIntegrations do
  use Ecto.Migration

  def change do
    alter table(:integrations) do
      add :slack_channel_name, :string
    end
  end
end
