defmodule GarrahanWeb.Router do
  use GarrahanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(Garrahan.Auth.LoadResourcePipeline)
  end

  pipeline :auth do
    # @TODO: Enable this and line 9 at user_controller.ex
    # plug(Garrahan.Auth.AuthAccessPipeline)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GarrahanWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", GarrahanWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/logout", AuthController, :logout

    scope "/" do
      pipe_through :auth

      resources "/users", UserController, except: [:new, :edit]
      resources "/diagnostics", DiagnosticController, except: [:new, :edit]
      resources "/surgeons", SurgeonController, except: [:new, :edit]
      resources "/patients", PatientController, except: [:new, :edit]
      resources "/surgeries", SurgeryController, except: [:new, :edit]
    end
  end
end
