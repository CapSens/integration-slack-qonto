defmodule CapsensQontoWeb.SessionController do
  use CapsensQontoWeb, :controller

  def new(conn, params) do
    render(conn, "new.html")
  end

  def delete(conn, params) do
    conn |> CapsensQontoWeb.Guardian.Plug.sign_out |> redirect(to: "/")
  end
end
