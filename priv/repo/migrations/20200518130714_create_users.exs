defmodule MyBlog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :encoded_password, :string

      timestamps()
    end

  end
end
