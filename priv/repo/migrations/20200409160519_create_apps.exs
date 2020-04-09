defmodule CapsensQonto.Repo.Migrations.CreateApps do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :identifier, :string
      add :secret_key, :string
      add :iban, :string

      timestamps()
    end

  end
end
