defmodule GarrahanWeb.Router do
  use GarrahanWeb, :router

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

  scope "/", GarrahanWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", GarrahanWeb do
    pipe_through :api

    resources "/diagnostics", DiagnosticController, except: [:new, :edit]
  end
end