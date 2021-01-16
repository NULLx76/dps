defmodule Dps.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dps.Poem

  @derive {Jason.Encoder, only: [:id, :name, :poems]}
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
