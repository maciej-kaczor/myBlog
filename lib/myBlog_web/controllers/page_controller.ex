defmodule MyBlogWeb.PageController do
  use MyBlogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def chat_room(conn, _params) do
    render(conn, "chat_room.html")
  end
end
