defmodule CapsensQontoWeb.IntegrationController do
  use CapsensQontoWeb, :controller

  def index(conn, _params) do
    integrations = CapsensQonto.Integration.list(conn.assigns[:current_user].id)
    render(conn, "index.html", integrations: integrations)
  end

  def new(conn, _params) do
    changeset = CapsensQonto.Integration.changeset(%CapsensQonto.Integration{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"integration" => integration_params}) do
    case CapsensQonto.Integration.create(Map.put(integration_params, "user", conn.assigns[:current_user])) do
      {:ok, integration} ->
        conn
        |> put_flash(:info, pgettext("integration", "creation_success"))
        |> redirect(to: Routes.integration_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    integration = CapsensQonto.Repo.get_by!(CapsensQonto.Integration, user_id: conn.assigns[:current_user].id, id: id)
    changeset   = CapsensQonto.Integration.update_changeset(integration)

    render(conn, "edit.html", integration: integration, changeset: changeset)
  end

  def update(conn, %{"id" => id, "integration" => integration_params}) do
    integration = CapsensQonto.Repo.get_by!(CapsensQonto.Integration, user_id: conn.assigns[:current_user].id, id: id)
    changeset   = CapsensQonto.Integration.update_changeset(integration, integration_params)

    case CapsensQonto.Integration.update(changeset) do
      {:ok, integration} ->
        conn
        |> put_flash(:info, pgettext("integration", "update_success"))
        |> redirect(to: Routes.integration_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", integration: integration, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    integration = CapsensQonto.Repo.get_by!(CapsensQonto.Integration, user_id: conn.assigns[:current_user].id, id: id)
    CapsensQonto.Repo.delete(integration)

    conn
    |> put_flash(:info, pgettext("integration", "deletion_success"))
    |> redirect(to: Routes.integration_path(conn, :index))
  end
end
