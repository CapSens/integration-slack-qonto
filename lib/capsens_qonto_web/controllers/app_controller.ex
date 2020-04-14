defmodule CapsensQontoWeb.AppController do
  use CapsensQontoWeb, :controller

  def new(conn, _params) do
    changeset = CapsensQonto.App.changeset(%CapsensQonto.App{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"app" => app_params}) do
    case CapsensQonto.App.create(app_params) do
      {:ok, app} ->
        conn
        |> put_flash(:info, pgettext("app", "creation_success"))
        |> redirect(to: Routes.app_path(conn, :edit, app.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    app       = CapsensQonto.App.get!(id)
    changeset = CapsensQonto.App.qonto_changeset(app)

    render(conn, "edit.html", app: app, changeset: changeset)
  end

  def update(conn, %{"id" => id, "app" => app_params}) do
    app       = CapsensQonto.App.get!(id)
    changeset = CapsensQonto.App.qonto_changeset(app, app_params)

    case CapsensQonto.App.update(changeset) do
      {:ok, app} ->
        conn
        |> put_flash(:info, pgettext("app", "update_success"))
        |> redirect(to: Routes.app_path(conn, :edit, app.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", app: app, changeset: changeset)
    end
  end
end
