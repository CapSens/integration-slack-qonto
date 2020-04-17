defmodule CapsensQontoWeb.Router do
  use CapsensQontoWeb, :router
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline,
      module: CapsensQontoWeb.Guardian,
      error_handler: CapsensQontoWeb.AuthErrorHandler

    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
    plug CapsensQontoWeb.Plugs.CurrentUser
  end

  scope "/", CapsensQontoWeb do
    pipe_through :browser

    resources "/sessions", SessionController, only: [:new]
    get "/slack/auth", SlackAuthController, :new
  end

  scope "/", CapsensQontoWeb do
    pipe_through [:browser, :auth]

    resources "/integrations", IntegrationController, only: [:new, :create, :edit, :update]
    get "/", IntegrationController, :new
  end

  # TODO: remove
  def handle_errors(conn, err) do
    IO.inspect "Something happened when handling web request for the user:"
    IO.inspect conn.assigns.current_user
    IO.inspect "The error was:"
    IO.inspect err

    conn
  end
end
