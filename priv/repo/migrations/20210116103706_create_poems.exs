defmodule Dps.Repo.Migrations.CreatePoems do
  use Ecto.Migration

  def change do
    create table(:poems) do
      add :title, :string
      add :epigraph, :string
      add :content, :text
      add :author_id, references(:authors), null: false

      timestamps()
    end
  end
end
