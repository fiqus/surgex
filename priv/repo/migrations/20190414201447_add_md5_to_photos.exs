defmodule Surgex.Repo.Migrations.AddMd5ToPhotos do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :md5, :string
    end

    create unique_index(:photos, [:md5])
  end
end
