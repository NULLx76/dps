defmodule DpsWeb.AuthorPageController do
  use DpsWeb, :controller
  alias Dps.{Poem, Author}

  def index(conn, _params) do
    authors = Author.Query.all_authors()
    render(conn, "index.html", authors: authors, title: "Authors")
  end

  def show(conn, %{"id" => id}) do
    author_id = String.to_integer(id)

    poems = Poem.Query.get_all_poems_by_author(author_id)
    author = Author.Query.get_author_by_id(author_id)

    render(conn, "show.html", poems: poems, author: author, title: "Poems by " <> author.name)
  end

  def new(conn, _params) do
    changeset = Author.changeset(%Author{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    %{"author" => author} = params

    with {:ok, %Author{}} <- Author.Query.create_author(author) do
      redirect(conn, to: Routes.author_page_path(conn, :index))
    end
  end
end
