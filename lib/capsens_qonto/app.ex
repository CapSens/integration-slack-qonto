defmodule CapsensQonto.App do
  use Ecto.Schema
  import Ecto.Changeset

  schema "apps" do
    field :iban, :string
    field :identifier, :string
    field :secret_key, :string

    timestamps()
  end

  def changeset(app, attrs \\ %{}) do
    app
    |> cast(attrs, [:identifier, :secret_key, :iban])
    |> validate_required([:identifier, :secret_key, :iban])
  end

  def create(attrs \\ %{}) do
    %CapsensQonto.App{}
    |> CapsensQonto.App.changeset(attrs)
    |> CapsensQonto.Repo.insert()
  end

  def list do
    CapsensQonto.Repo.all(CapsensQonto.App)
  end
end
