defmodule CapsensQontoWeb.AppController do
  use CapsensQontoWeb, :controller

  def new(conn, _params) do
    changeset = CapsensQonto.App.changeset(%CapsensQonto.App{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"app" => app_params}) do
    case CapsensQonto.App.create(app_params) do
      {:ok, app} ->
        conn |> put_flash(:info, "App created successfully.") |> redirect(to: Routes.app_path(conn, :edit, app.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    app       = CapsensQonto.App.get!(id)
    changeset = CapsensQonto.App.change(app)
    result    = CapsensQonto.Transactions.list(app.identifier, app.secret_key, app.iban, app.bank_account)

    render(conn, "edit.html", app: app, changeset: changeset, result: result)
  end

  def update(conn, %{"id" => id, "app" => app_params}) do
    app = CapsensQonto.App.get!(id)

    case CapsensQonto.App.update(app, app_params) do
      {:ok, app} ->
        conn |> put_flash(:info, "App updated successfully.") |> redirect(to: Routes.app_path(conn, :edit, app.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", app: app, changeset: changeset)
    end
  end
end
