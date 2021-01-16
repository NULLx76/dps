defmodule DpsWeb.PoemController do
  use DpsWeb, :controller
  alias Dps.Poem

  def index(conn, _params) do
    poems = Poem.Query.get_all_poems()
    json(conn, poems)
  end

  def show(conn, %{"id" => id}) do
    poem = id |> String.to_integer() |> Poem.Query.get_poem_by_id()
    json(conn, poem)
  end

  def create(conn, params) do
    with {:ok, %Poem{} = poem} <- Poem.Query.create_poem(params) do
      conn
      |> put_status(:created)
      |> json(poem)
    end
  end
end
