defmodule MyBlogWeb.PostController do
  use MyBlogWeb, :controller

  alias MyBlog.Blog
  alias MyBlog.Blog.Post
  alias MyBlog.Blog.Comment
  alias MyBlog.Repo

  require Logger

  plug :scrub_params, "comment" when action in [:add_comment]

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Blog.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id) |> Repo.preload([:comments])
    changeset = Blog.change_comment(%Comment{})
    render(conn, "show.html", post: post, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    changeset = Blog.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def add_comment(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    changeset = Blog.Comment.changeset(%Blog.Comment{}, comment_params)
    post = Post |> Repo.get(post_id) |> Repo.preload([:comments])
    
    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Comment added.")
      |> redirect(to: Routes.post_path(conn, :show, post))
    else
      render(conn, "show.html", post: post, changeset: changeset)
    end
  end
end
