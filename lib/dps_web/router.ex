defmodule DpsWeb.Router do
  use DpsWeb, :router

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

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug :auth
  end

  defp auth(conn, _opts) do
    username = System.fetch_env!("AUTH_USERNAME")
    password = System.fetch_env!("AUTH_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

  # The website
  scope "/", DpsWeb do
    pipe_through :browser

    get "/", PageController, :poems
    get "/poems", PageController, :poems
    get "/poems/:id", PageController, :poem

    get "/authors", PageController, :authors
    get "/authors/:id", PageController, :author
  end

  # Public api
  scope "/api", DpsWeb do
    pipe_through :api

    get "/authors", AuthorController, :index
    get "/authors/:id", AuthorController, :show

    get "/poems", PoemController, :index
    get "/poems/:id", PoemController, :show
  end

  # Authenticated api
  scope "/api", DpsWeb do
    pipe_through :api_auth

    post "/authors", AuthorController, :create
    post "/poems", PoemController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DpsWeb.Telemetry, ecto_repos: [Dps.Repo]
    end
  end
end
