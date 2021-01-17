defmodule DpsWeb.PoemPageController do
  use DpsWeb, :controller
  alias Dps.{Poem, Author}

  def index(conn, _params) do
    poems = Poem.Query.get_all_poems()
    render(conn, "index.html", poems: poems)
  end

  def show(conn, %{"id" => id}) do
    poem = id |> String.to_integer() |> Poem.Query.get_poem_by_id()
    title = poem.title <> " by " <> poem.author.name
    render(conn, "show.html", poem: poem, title: title)
  end

  def new(conn, _params) do
    changeset = Poem.changeset(%Poem{})

    authors =
      Author.Query.all_authors()
      |> Enum.map(fn author ->
        [key: author.name, value: author.id]
      end)

    render(conn, "new.html", changeset: changeset, authors: authors)
  end

  def create(conn, params) do
    %{"poem" => poem} = params

    with {:ok, %Poem{id: id}} <- Poem.Query.create_poem(poem) do
      redirect(conn, to: Routes.poem_page_path(conn, :show, id))
    end
  end
end
