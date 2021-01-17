defmodule DpsWeb.AuthorController do
  use DpsWeb, :controller
  alias Dps.Author

  def index(conn, _params) do
    authors = Author.Query.all_authors()
    json(conn, authors)
  end

  def show(conn, %{"id" => id}) do
    author = String.to_integer(id) |> Author.Query.get_author_by_id()
    json(conn, author)
  end

  def create(conn, params) do
    with {:ok, %Author{} = author} <- Author.Query.create_author(params) do
      conn
      |> put_status(:created)
      |> json(author)
    end
  end
end
