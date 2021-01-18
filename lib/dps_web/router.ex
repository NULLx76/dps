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

  # Authenticated Browser pages
  scope "/", DpsWeb do
    pipe_through [:browser, :auth]

    get "/authors/new", AuthorPageController, :new
    post "/authors/new", AuthorPageController, :create

    get "/poems/new", PoemPageController, :new
    post "/poems/new", PoemPageController, :create

    live_dashboard "/dashboard", metrics: DpsWeb.Telemetry, ecto_repos: [Dps.Repo]
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
    pipe_through [:api, :auth]

    post "/authors", AuthorController, :create
    post "/poems", PoemController, :create
  end
end
