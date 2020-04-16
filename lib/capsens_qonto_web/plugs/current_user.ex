defmodule CapsensQontoWeb.Plugs.CurrentUser do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    assign(conn, :current_user, CapsensQontoWeb.Guardian.Plug.current_resource(conn))
  end
end
