defmodule DpsWeb.PageController do
  use DpsWeb, :controller
  alias Dps.Poem

  def index(conn, _params) do
    poems = Poem.Query.get_all_poems()

    conn
    |> render("index.html", poems: poems)
  end

  def poem(conn, %{"id" => id}) do
    poem = id |> String.to_integer() |> Poem.Query.get_poem_by_id()
    render(conn, "poem.html", poem: poem)
  end
end
