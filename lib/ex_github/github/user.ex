defmodule ExGithub.User do
  @client ExGithub.Client

  def fetch(client // @client, login_name) do
    client.request(:GET, "users/#{login_name}")
  end

  def followers(client // @client, login_name) do
    client.request(:GET, "users/#{login_name}/followers")
  end
end
