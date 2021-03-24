defmodule Dps.Poem do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Dps.{Author, Cache, Repo}
  alias __MODULE__

  @derive {Jason.Encoder, only: [:id, :title, :epigraph, :content, :author, :author_id, :translator, :translator_id]}
  schema "poems" do
    field :title, :string
    field :epigraph, :string
    field :content, :string

    belongs_to :author, Author
    belongs_to :translator, Author

    timestamps()
  end

  @doc false
  def changeset(poem, attrs \\ %{}) do
    poem
    |> cast(attrs, [:title, :epigraph, :content, :author_id, :translator_id])
    |> validate_required([:title, :content, :author_id])
    |> unique_constraint([:title, :author_id])
    |> foreign_key_constraint(:author_id)
    |> foreign_key_constraint(:translator_id)
  end

  def list_poems(search \\ "") do
    wildcard_search = "%#{search}%"

    from(p in Poem,
      select: %Poem{id: p.id, author_id: p.author_id, title: p.title},
      where: ilike(p.title, ^wildcard_search),
      order_by: [desc: p.id]
    )
    |> Repo.all()
    |> Repo.preload(:author)
  end

  def list_poems_by_author(author_id) do
    from(p in Poem,
      select: %Poem{id: p.id, author_id: p.author_id, translator_id: p.translator_id, title: p.title},
      where: p.author_id == ^author_id or p.translator_id == ^author_id,
      order_by: [asc: p.title]
    )
    |> Repo.all()
  end

  def get_poem(id) do
    case Cache.get({:poem, id}) do
      nil ->
        :telemetry.execute([:dps, :cache, :miss], %{poem: id})

        poem =
          Poem
          |> Repo.get(id)
          |> Repo.preload([:author, :translator])

        Cache.put({:poem, id}, poem)

      v ->
        :telemetry.execute([:dps, :cache, :hit], %{poem: id})
        v
    end
  end

  def create_poem(attrs) do
    %Poem{}
    |> Poem.changeset(attrs)
    |> Repo.insert()
  end

  def update_poem(id, attrs) do
    Cache.delete({:poem, id})

    Repo.get(Poem, id)
    |> Poem.changeset(attrs)
    |> Repo.update()
  end
end
