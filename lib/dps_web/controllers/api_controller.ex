defmodule DpsWeb.ApiController do
  use DpsWeb, :controller
  alias Dps.{Repo, Author, Poem}

  def authors(conn, _params) do
    authors = Repo.all(Author)
    json(conn, authors)
  end

  def author(conn, %{"id" => id}) do
    author = Repo.get(Author, String.to_integer(id))
    json(conn, author)
  end

  def poems(conn, _params) do
    poems = Poem.Query.get_all_poems()
    json(conn, poems)
  end

  def poem(conn, %{"id" => id}) do
    poem = id |> String.to_integer() |> Poem.Query.get_poem_by_id()
    json(conn, poem)
  end
end
