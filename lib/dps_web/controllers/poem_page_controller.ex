defmodule DpsWeb.PoemPageController do
  use DpsWeb, :controller
  alias Dps.Poem

  def index(conn, _params) do
    poems = Poem.Query.get_all_poems()
    render(conn, "index.html", poems: poems)
  end

  def show(conn, %{"id" => id}) do
    poem = id |> String.to_integer() |> Poem.Query.get_poem_by_id()
    title = poem.title <> " by " <> poem.author.name
    render(conn, "show.html", poem: poem, title: title)
  end
end
