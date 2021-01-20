defmodule DpsWeb.PoemController do
  use DpsWeb, :controller
  alias Dps.{Poem, Author}

  action_fallback DpsWeb.FallbackController

  def index(conn, params) do
    query = get_in(params, ["query"])

    poems = Poem.Query.get_all_poems(query)
    render(conn, "index.html", poems: poems)
  end

  def show(conn, %{"id" => id}) do
    with {id, ""} <- Integer.parse(id),
         %Poem{} = poem <- Poem.Query.get_poem_by_id(id) do
      render(conn, "show.html", poem: poem, title: "#{poem.title} by #{poem.author.name}")
    else
      _ -> {:error, :not_found}
    end
  end

  defp make_author_list do
    Author.Query.all_authors()
    |> Enum.map(&{&1.name, &1.id})
  end

  def new(conn, params) do
    changeset = Poem.changeset(%Poem{})
    select = get_in(params, ["author"]) || 0
    render(conn, "new.html", changeset: changeset, authors: make_author_list(), select: select)
  end

  def create(conn, params) do
    poem = get_in(params, ["poem"])

    with {:ok, %Poem{id: id}} <- Poem.Query.create_poem(poem) do
      redirect(conn, to: Routes.poem_path(conn, :show, id))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid poem")
        |> render("new.html", changeset: changeset, authors: make_author_list(), select: 0)
    end
  end

  def edit(conn, %{"id" => id}) do
    with {id, ""} <- Integer.parse(id),
         %Poem{} = poem <- Poem.Query.get_poem_by_id(id) do
      render(conn, "edit.html", changeset: Poem.changeset(poem), authors: make_author_list())
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "poem" => poem}) do
    {id, ""} = Integer.parse(id)
    Poem.Query.update_poem(id, poem)
    redirect(conn, to: Routes.poem_path(conn, :show, id))
  end
end
