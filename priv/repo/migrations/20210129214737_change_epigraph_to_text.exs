defmodule Dps.Repo.Migrations.ChangeEpigraphToText do
  use Ecto.Migration

  def change do
    alter table(:poems) do
      modify :epigraph, :text, from: :string
    end
  end
end
