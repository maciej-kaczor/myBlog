defmodule MyBlog.Repo.Migrations.RenameUserEncodedPassword do
  use Ecto.Migration

  def change do

    rename table(:users), :encoded_password, to: :encrypted_password
  end
end
