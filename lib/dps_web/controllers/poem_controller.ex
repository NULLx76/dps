defmodule DpsWeb.PoemController do
  use DpsWeb, :controller
  alias Dps.Poem

  def poems(conn, _params) do
    poems = Poem.Query.get_all_poems()
    json(conn, poems)
  end

  def poem(conn, %{"id" => id}) do
    poem = id |> String.to_integer() |> Poem.Query.get_poem_by_id()
    json(conn, poem)
  end
end
