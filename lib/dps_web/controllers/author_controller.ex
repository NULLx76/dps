defmodule DpsWeb.AuthorController do
  use DpsWeb, :controller
  alias Dps.{Author, Poem}

  action_fallback DpsWeb.FallbackController

  def index(conn, params) do
    query = get_in(params, ["query"])

    authors = Author.list_authors(query)
    render(conn, "index.html", authors: authors, title: "Authors")
  end

  def show(conn, %{"id" => id}) do
    with {author_id, ""} <- Integer.parse(id),
         poems when is_list(poems) <- Poem.list_poems_by_author(author_id),
         %Author{} = author <- Author.get_author(author_id) do
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

    case Author.create_author(author) do
      {:ok, %Author{id: id}} ->
        redirect(conn, to: Routes.poem_path(conn, :new, %{"author" => id}))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid author")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {id, ""} <- Integer.parse(id),
         %Author{} = author <- Author.get_author(id) do
      render(conn, "edit.html", changeset: Author.changeset(author))
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "author" => author}) do
    {id, ""} = Integer.parse(id)

    case Author.update_author(id, author) do
      {:ok, %Author{id: id}} ->
        redirect(conn, to: Routes.author_path(conn, :show, id))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid author")
        |> render("edit.html", changeset: changeset)
    end
  end
end
