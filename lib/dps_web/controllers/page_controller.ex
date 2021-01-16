defmodule DpsWeb.PageController do
  use DpsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
