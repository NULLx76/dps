defmodule DpsWeb.AuthorController do
  use DpsWeb, :controller
  alias Dps.{Repo, Author}

  def index(conn, _params) do
    authors = Repo.all(Author)
    json(conn, authors)
  end

  def show(conn, %{"id" => id}) do
    author = Repo.get(Author, String.to_integer(id))
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
