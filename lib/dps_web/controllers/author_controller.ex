defmodule DpsWeb.AuthorController do
  use DpsWeb, :controller
  alias Dps.{Repo, Author, Poem}
  import Ecto.Query

  def authors(conn, _params) do
    poem_query = from p in Poem, select: %Poem{id: p.id, title: p.title}
    authors = Repo.all(from a in Author, preload: [poems: ^poem_query])
    json(conn, authors)
  end
end
