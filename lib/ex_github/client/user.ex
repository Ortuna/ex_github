defmodule ExGithub.User do
  alias ExGithub.Client

  def user(client, login_name) do
    Client._request(client, :GET, "users/#{login_name}")
  end

end
