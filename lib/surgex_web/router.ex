defmodule SurgexWeb.Router do
  use SurgexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Surgex.Auth.LoadResourcePipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Surgex.Auth.AuthAccessPipeline
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", SurgexWeb do
    pipe_through :browser

    get "/", IndexController, :index

    # INSECURE: We could change a password by just knowing the user ID unless we check the token inside!
    # put("/users/:id/password", UserController, :update_password)
  end

  scope "/api", SurgexWeb do
    pipe_through :api

    post "/token", AuthController, :token
    post "/auth", AuthController, :is_auth
    post "/users/recover", UserController, :recover
    get "/users/recover", UserController, :recover
    put "/users/recover", UserController, :recover
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
