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

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", GarrahanWeb do
    pipe_through :browser

    get "/", IndexController, :index

    # INSECURE: We could change a password by just knowing the user ID unless we check the token inside!
    # put("/users/:id/password", UserController, :update_password)
  end

  scope "/api", GarrahanWeb do
    pipe_through :api

    post "/token", AuthController, :token
    post "/auth", AuthController, :is_auth
    post "/users/recover", UserController, :recover
    get "/users/activate", UserController, :activate
    put "/users/activate", UserController, :activate

    scope "/" do
      pipe_through :auth

      resources "/users", UserController, except: [:new, :edit, :create, :delete]
      resources "/diagnostics", DiagnosticController, except: [:new, :edit]
      resources "/surgeons", SurgeonController, except: [:new, :edit]
      resources "/patients", PatientController, except: [:new, :edit]
      resources "/surgeries", SurgeryController, except: [:new, :edit]
    end
  end
end
