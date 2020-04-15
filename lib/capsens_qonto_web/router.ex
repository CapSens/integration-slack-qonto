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

  scope "/", CapsensQontoWeb do
    pipe_through :browser

    get "/", SessionController, :new

    resources "/apps", AppController, only: [:new, :create, :edit, :update]
    get "/slack/auth", SlackAuthController, :new
  end

  scope "/api", CapsensQontoWeb do
    pipe_through :api

    get "/", Api.TestController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CapsensQontoWeb do
  #   pipe_through :api
  # end
end
