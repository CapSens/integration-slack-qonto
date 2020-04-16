defmodule CapsensQontoWeb.IntegrationController do
  use CapsensQontoWeb, :controller

  def new(conn, _params) do
    changeset = CapsensQonto.Integration.changeset(%CapsensQonto.Integration{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"integration" => integration_params}) do
    case CapsensQonto.Integration.create(integration_params) do
      {:ok, integration} ->
        conn
        |> put_flash(:info, pgettext("integration", "creation_success"))
        |> redirect(to: Routes.integration_path(conn, :edit, integration.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    integration = CapsensQonto.Integration.get!(id)
    changeset   = CapsensQonto.Integration.changeset(integration)

    render(conn, "edit.html", integration: integration, changeset: changeset)
  end

  def update(conn, %{"id" => id, "integration" => integration_params}) do
    integration = CapsensQonto.Integration.get!(id)
    changeset   = CapsensQonto.Integration.changeset(integration, integration_params)

    case CapsensQonto.Integration.update(changeset) do
      {:ok, integration} ->
        conn
        |> put_flash(:info, pgettext("integration", "update_success"))
        |> redirect(to: Routes.integration_path(conn, :edit, integration.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", integration: integration, changeset: changeset)
    end
  end
end
