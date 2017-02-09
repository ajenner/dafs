defmodule Dafs.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :path, :string
      add :name, :string
      add :size, :integer
      add :contents, :bytea
      add :user_id, :integer
      timestamps
    end
  end
end
