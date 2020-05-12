defmodule CapsensQonto.Repo.Migrations.AddWorkspaceNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slack_team_name, :string
    end
  end
end
