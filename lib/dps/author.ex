defmodule Dps.Author do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Dps.{Cache, Poem, Repo}
  alias __MODULE__

  @derive {Jason.Encoder, only: [:id, :name]}
  schema "authors" do
    field :name, :string

    has_many :poems, Poem

    timestamps()
  end

  @doc false
  def changeset(author, attrs \\ %{}) do
    author
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def create_author(attrs) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  def list_authors(query \\ "", sort_by \\ [asc: :name]) do
    wildcard_query = "%#{query}%"

    from(a in Author,
      order_by: ^sort_by,
      where: ilike(a.name, ^wildcard_query)
    )
    |> Repo.all()
  end

  def get_author(id) do
    case Cache.get({:author_by_id, id}) do
      nil ->
        :telemetry.execute([:dps, :cache, :miss], %{author_by_id: id})
        author = Repo.get(Author, id)
        Cache.put({:author_by_id, id}, author)

      v ->
        :telemetry.execute([:dps, :cache, :hit], %{author_by_id: id})
        v
    end
  end

  def update_author(id, attrs) do
    Cache.delete({:author_by_id, id})

    Repo.get(Author, id)
    |> Author.changeset(attrs)
    |> Repo.update()
  end
end
