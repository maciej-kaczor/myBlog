defmodule MyBlog.Accounts.Encryption do
    alias Comeonin.Pdkbf2
    alias MyBlog.Accounts.User

    def hash_password(password), do: Pbkdf2.hash_pwd_salt(password)

    def validate_password(%User{} = user, password), do: Pbkdf2.check_pass(user, password)
end