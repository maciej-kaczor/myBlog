
defmodule MyBlogWeb.SessionController do
    use MyBlogWeb, :controller
  
    alias MyBlog.Accounts.Auth
    alias MyBlog.Repo
  
    def new(conn, _params) do
      render(conn, "new.html")
    end
  
    @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
    def create(conn, %{"session" => auth_params}) do
      user = MyBlog.Accounts.get_by_name(auth_params["name"])
      case Pbkdf2.check_pass(user, auth_params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.page_path(conn, :index))
      :error ->
        conn
        |> put_flash(:error, "There was a problem with your username/password")
        |> render("new.html")
      end
    end
  
    def delete(conn, _params) do
      conn
      |> delete_session(:current_user_id)
      |> put_flash(:info, "Signed out successfully.")
      |> redirect(to: Routes.session_path(conn, :new))
    end
end
  