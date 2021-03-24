defmodule Dps.Repo.Migrations.AddTranslator do
  use Ecto.Migration

  def change do
    alter table(:poems) do
      add :translator_id, references(:authors)
    end
  end
end
