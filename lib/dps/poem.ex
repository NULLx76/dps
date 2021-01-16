defmodule Dps.Poem do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Dps.Author

  @derive {Jason.Encoder, only: [:id, :title, :epigraph, :content, :author]}
  schema "poems" do
    field :title, :string
    field :epigraph, :string
    field :content, :string

    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(poem, attrs) do
    poem
    |> cast(attrs, [:title, :epigraph, :content, :author])
    |> validate_required([:title, :epigraph, :content, :author])
  end
end

defmodule Dps.Poem.Query do
  import Ecto.Query
  alias Dps.{Repo, Poem}

  @spec get_all_poems :: nil | [%Poem{}]
  def get_all_poems do
    from(p in Poem, select: %Poem{id: p.id, author_id: p.author_id, title: p.title})
    |> Repo.all()
    |> Repo.preload(:author)
  end

  @spec get_poem_by_id(integer()) :: nil | %Poem{}
  def get_poem_by_id(id) do
    Poem
    |> Repo.get(id)
    |> Repo.preload(:author)
  end
end
