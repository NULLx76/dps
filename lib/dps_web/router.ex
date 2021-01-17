defmodule DpsWeb.Router do
  use DpsWeb, :router
  import Phoenix.LiveDashboard.Router

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

  defp auth(conn, _opts) do
    Plug.BasicAuth.basic_auth(conn, Application.fetch_env!(:dps, :basic_auth))
  end

  # Browser pages
  scope "/", DpsWeb do
    pipe_through :browser

    get "/", PoemPageController, :index
    get "/poems", PoemPageController, :index
    get "/poems/:id", PoemPageController, :show

    get "/authors", AuthorPageController, :index
    get "/authors/:id", AuthorPageController, :show
  end

  # Authenticated Browser pages
  scope "/" do
    pipe_through :browser
    pipe_through :auth

    live_dashboard "/dashboard", metrics: DpsWeb.Telemetry, ecto_repos: [Dps.Repo]
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
    pipe_through :api
    pipe_through :auth

    post "/authors", AuthorController, :create
    post "/poems", PoemController, :create
  end
end
