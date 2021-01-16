defmodule Dps.Poem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dps.Author

  @derive {Jason.Encoder, only: [:id, :title, :epigraph, :content]}
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
