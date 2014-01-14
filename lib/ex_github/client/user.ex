defmodule ExGithub.User do
  alias ExGithub.Client

  defmacro __using__(_) do
    quote do
      def user(client, login_name) do
        Client._request(client, :GET, "users/#{login_name}")
      end 
    end
  end
end
