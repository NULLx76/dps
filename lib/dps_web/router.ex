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

    get "/authors/new", AuthorController, :new
    post "/authors/new", AuthorController, :create

    get "/poems/new", PoemController, :new
    post "/poems/new", PoemController, :create
    get "/poems/:id/edit", PoemController, :edit
    put "/poems/:id/edit", PoemController, :update

    live_dashboard "/dashboard", metrics: DpsWeb.Telemetry, ecto_repos: [Dps.Repo]
  end

  # Browser pages
  scope "/", DpsWeb do
    pipe_through :browser

    get "/", PoemController, :index
    get "/poems", PoemController, :index
    get "/poems/:id", PoemController, :show

    get "/authors", AuthorController, :index
    get "/authors/:id", AuthorController, :show
  end
end
