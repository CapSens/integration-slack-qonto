defmodule CapsensQontoWeb.Api.TestController do
  use CapsensQontoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json")
  end
end
