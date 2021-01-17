defmodule Dps.Poem do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Dps.Author

  @derive {Jason.Encoder, only: [:id, :title, :epigraph, :content, :author, :author_id]}
  schema "poems" do
    field :title, :string
    field :epigraph, :string
    field :content, :string

    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(poem, attrs \\ %{}) do
    poem
    |> cast(attrs, [:title, :epigraph, :content, :author_id])
    |> validate_required([:title, :content, :author_id])
    |> validate_length(:epigraph, max: 255)
    |> unique_constraint([:title, :author_id])
    |> foreign_key_constraint(:author_id)
  end
end

defmodule Dps.Poem.Query do
  import Ecto.Query
  alias Dps.{Repo, Poem}
  alias Dps.Cache

  @spec get_all_poems :: nil | [%Poem{}]
  def get_all_poems do
    from(p in Poem, select: %Poem{id: p.id, author_id: p.author_id, title: p.title})
    |> Repo.all()
    |> Repo.preload(:author)
  end

  def get_all_poems_by_author(author_id) do
    from(p in Poem,
      select: %Poem{id: p.id, author_id: p.author_id, title: p.title},
      where: p.author_id == ^author_id
    )
    |> Repo.all()
  end

  def get_poem_by_id(id) do
    case Cache.get({:poem, id}) do
      nil ->
        :telemetry.execute([:dps, :cache, :miss], %{poem: id})

        poem =
          Poem
          |> Repo.get(id)
          |> Repo.preload(:author)

        Cache.put({:poem, id}, poem)

      v ->
        :telemetry.execute([:dps, :cache, :hit], %{poem: id})
        v
    end
  end

  def create_poem(attrs \\ %{}) do
    %Poem{}
    |> Poem.changeset(attrs)
    |> Repo.insert()
  end
end
