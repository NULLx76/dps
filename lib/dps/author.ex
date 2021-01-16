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
  alias Dps.{Repo,Author}

  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end
end
