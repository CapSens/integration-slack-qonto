defmodule CapsensQontoWeb.Router do
  use CapsensQontoWeb, :router

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
end
