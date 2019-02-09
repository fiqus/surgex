defmodule GarrahanWeb.Router do
  use GarrahanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Garrahan.Auth.LoadResourcePipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Garrahan.Auth.AuthAccessPipeline
  end

  scope "/", GarrahanWeb do
    pipe_through :browser

    get "/", IndexController, :index
  end

  scope "/api", GarrahanWeb do
    pipe_through :api

    post "/token", AuthController, :token

    scope "/" do
      pipe_through :auth

      resources "/users", UserController, except: [:new, :edit]
      get("/users/password", UserController, :set_password)
      put("/users/:id/password", UserController, :update_password)
      resources "/diagnostics", DiagnosticController, except: [:new, :edit]
      resources "/surgeons", SurgeonController, except: [:new, :edit]
      resources "/patients", PatientController, except: [:new, :edit]
      resources "/surgeries", SurgeryController, except: [:new, :edit]
    end
  end
end
