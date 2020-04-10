defmodule CapsensQonto.App do
  use Ecto.Schema
  import Ecto.Changeset

  schema "apps" do
    field :iban, :string
    field :identifier, :string
    field :secret_key, :string
    field :transaction_type, {:array, :string}

    timestamps()
  end

  def changeset(app, attrs \\ %{}) do
    app
    |> cast(attrs, [:identifier, :secret_key, :iban, :transaction_type])
    |> validate_required([:identifier, :secret_key, :iban, :transaction_type])
    |> validate_subset(:transaction_type, CapsensQonto.App.transaction_types)
  end

  def create(attrs \\ %{}) do
    %CapsensQonto.App{}
    |> CapsensQonto.App.changeset(attrs)
    |> CapsensQonto.Repo.insert()
  end

  def transaction_types do
    ["Crédit", "Débit"]
  end

  def list do
    CapsensQonto.Repo.all(CapsensQonto.App)
  end
end
