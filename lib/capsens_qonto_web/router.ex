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

    resources "/apps", AppController, only: [:new, :create, :edit, :update]
    get "/", AppController, :new
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
