defmodule CapsensQontoWeb.AppController do
  use CapsensQontoWeb, :controller

  def new(conn, _params) do
    changeset = CapsensQonto.App.changeset(%CapsensQonto.App{})
    render(conn, "new.html", changeset: changeset)
  end
end
