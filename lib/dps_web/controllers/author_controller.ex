defmodule DpsWeb.AuthorController do
  use DpsWeb, :controller
  alias Dps.{Repo, Author}

  def authors(conn, _params) do
    authors = Repo.all(Author)
    json(conn, authors)
  end

  def author(conn, %{"id" => id}) do
    author = Repo.get(Author, String.to_integer(id))
    json(conn, author)
  end
end
