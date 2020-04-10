defmodule CapsensQontoWeb.AppController do
  use CapsensQontoWeb, :controller

  def new(conn, _params) do
    changeset = CapsensQonto.App.changeset(%CapsensQonto.App{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"app" => app_params}) do
    case CapsensQonto.App.create(app_params) do
      {:ok, app} ->
        conn |> put_flash(:info, "App created successfully") |> redirect(to: Routes.app_path(conn, :new))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
