defmodule Dps.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dps.Poem

  @derive {Jason.Encoder, only: [:id, :name]}
  schema "authors" do
    field :name, :string

    has_many :poems, Poem

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

defmodule Dps.Author.Query do
  alias Dps.{Repo, Author, Cache}

  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  def all_authors do
    case Cache.get(:all_authors) do
      nil ->
        :telemetry.execute([:dps, :cache, :miss], %{all_authors: nil})
        authors = Repo.all(Author)
        Cache.put(:all_authors, authors)

      v ->
        :telemetry.execute([:dps, :cache, :hit], %{all_authors: nil})
        v
    end
  end

  def get_author_by_id(id) do
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
end
