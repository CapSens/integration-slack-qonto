defmodule CapsensQontoWeb.SessionController do
  use CapsensQontoWeb, :controller

  def new(conn, params) do
    render(conn, "new.html")
  end
end
