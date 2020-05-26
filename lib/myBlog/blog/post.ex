defmodule MyBlog.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyBlog.Blog.Comment

  schema "posts" do
    field :content, :string
    field :title, :string

    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
