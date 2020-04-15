defmodule CapsensQontoWeb.AuthErrorHandler do
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  import Plug.Conn, only: [halt: 1]

  alias CapsensQontoWeb.Router.Helpers, as: Routes

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> put_flash(:error, to_string(type))
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end
end
