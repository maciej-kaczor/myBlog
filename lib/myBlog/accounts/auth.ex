defmodule MyBlog.Accounts.Auth do
    alias MyBlog.Accounts.{Encryption, User}

    def login(params, repo) do
        user = repo.get_by(User, name: String.downcase(params["name"]))
        case authenticate(user, params["password"]) do
            true -> {:ok, user}
            _    -> :error
        end
    end
    
    defp authenticate(user, password) do
        if user do
            authenticated_user = case Encryption.validate_password(user, password) do
                {:ok, validated_user} -> validated_user.name == user.name
                {:error, _} -> false
            end
        else
            nil
        end
    end
     
    def signed_in?(conn) do
        conn.assigns[:current_user]
    end
end
