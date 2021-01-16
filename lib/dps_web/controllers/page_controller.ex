defmodule DpsWeb.PageController do
  use DpsWeb, :controller
  alias Dps.{Poem, Repo, Author}

  def index(conn, _params) do
    poems = Poem.Query.get_all_poems()

    conn
    |> render("index.html", poems: poems)
  end

  def poem(conn, %{"id" => id}) do
    poem = id |> String.to_integer() |> Poem.Query.get_poem_by_id()
    title = poem.title <> " by " <> poem.author.name
    render(conn, "poem.html", poem: poem, title: title)
  end

  def author(conn, %{"id" => id}) do
    author_id = String.to_integer(id)

    poems = Poem.Query.get_all_poems_by_author(author_id)
    author = Repo.get(Author, author_id)

    render(conn, "author.html", poems: poems, author: author, title: "Poems by " <> author.name)
  end
end
