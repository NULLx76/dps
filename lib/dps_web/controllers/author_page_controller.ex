defmodule DpsWeb.AuthorPageController do
  use DpsWeb, :controller
  alias Dps.{Poem, Repo, Author}

  def index(conn, _params) do
    authors = Repo.all(Author)
    render(conn, "index.html", authors: authors, title: "Authors")
  end

  def show(conn, %{"id" => id}) do
    author_id = String.to_integer(id)

    poems = Poem.Query.get_all_poems_by_author(author_id)
    author = Repo.get(Author, author_id)

    render(conn, "show.html", poems: poems, author: author, title: "Poems by " <> author.name)
  end
end
