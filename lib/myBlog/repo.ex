defmodule MyBlog.Repo do
  use Ecto.Repo,
    otp_app: :myBlog,
    adapter: Ecto.Adapters.Postgres
end
