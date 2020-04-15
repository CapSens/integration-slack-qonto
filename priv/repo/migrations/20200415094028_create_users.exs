defmodule CapsensQonto.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :slack_access_token, :string
      add :slack_user_id, :string

      timestamps()
    end

    create unique_index(:users, :slack_user_id)
  end
end
