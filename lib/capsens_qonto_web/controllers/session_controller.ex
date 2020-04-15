defmodule CapsensQontoWeb.SessionController do
  use CapsensQontoWeb, :controller

  plug Guardian.Plug.Pipeline,
    module: CapsensQontoWeb.Guardian,
    error_handler: CapsensQontoWeb.AuthErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true

  def new(conn, params) do
    user = CapsensQontoWeb.Guardian.Plug.current_resource(conn)

    render(conn, "new.html", current_user: user)
  end
end
