defmodule MyBlog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyBlog.Accounts.Encryption

  require Logger

  schema "users" do
    field :encrypted_password, :string
    field :name, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password, :encrypted_password])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> validate_length(:name, min: 3)
    |> downcase_name
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    Logger.debug "encrypt_password: #{inspect(changeset)}"
    password = get_change(changeset, :password)
    if password do
      Logger.debug "encrypt_password if block"
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :encrypted_password, encrypted_password)
    else
      Logger.debug "encrypt_password else block"
      changeset
    end
  end

  defp downcase_name(changeset) do
    update_change(changeset, :name, &String.downcase/1)
  end

end
