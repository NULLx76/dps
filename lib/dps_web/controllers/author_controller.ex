defmodule DpsWeb.AuthorController do
  use DpsWeb, :controller
  alias Dps.{Poem, Author}

  action_fallback DpsWeb.FallbackController

  def index(conn, params) do
    query = get_in(params, ["query"])

    authors = Author.Query.all_authors(query)
    render(conn, "index.html", authors: authors, title: "Authors")
  end

  def show(conn, %{"id" => id}) do
    with {author_id, ""} <- Integer.parse(id),
         poems when is_list(poems) <- Poem.Query.get_all_poems_by_author(author_id),
         %Author{} = author <- Author.Query.get_author_by_id(author_id) do
      render(conn, "show.html", poems: poems, author: author, title: "Poems by #{author.name}")
    else
      _ -> {:error, :not_found}
    end
  end

  def new(conn, _params) do
    changeset = Author.changeset(%Author{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    author = get_in(params, ["author"])

    with {:ok, %Author{id: id}} <- Author.Query.create_author(author) do
      redirect(conn, to: Routes.poem_path(conn, :new, %{"author" => id}))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid author")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {id, ""} <- Integer.parse(id),
         %Author{} = author <- Author.Query.get_author_by_id(id) do
      render(conn, "edit.html", changeset: Author.changeset(author))
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "author" => author}) do
    {id, ""} = Integer.parse(id)

    with {:ok, %Author{id: id}} <- Author.Query.update_author(id, author) do
      redirect(conn, to: Routes.author_path(conn, :show, id))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid author")
        |> render("edit.html", changeset: changeset)
    end
  end
end
