defmodule Shorty.Repo.Migrations.AddLinksTable do
  use Ecto.Migration

  def change do
    create table("links", primary_key: false) do
      add :slug, :string, size: 8, primary_key: true
      add :url, :string, size: 4096, null: false

      timestamps()
    end
  end
end
