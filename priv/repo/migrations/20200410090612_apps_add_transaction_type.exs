defmodule CapsensQonto.Repo.Migrations.AppsAddTransactionType do
  use Ecto.Migration

  def change do
    alter table("apps") do
      add :transaction_type, {:array, :string}
    end
  end
end
