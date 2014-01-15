defmodule ExGithub.User do
  @client ExGithub.Client

  @doc """
  returns a users details
  """
  def fetch(client // @client, user_name) do
    client.request(:GET, "users/#{user_name}")
  end

  @doc """
  returns a users details
  """
  def user(client // @client, auth_token) do
    client.request(client.http_library, :GET, "user", auth_token: auth_token)
  end


  @doc """
  returns a list of followers for a particular user
  """
  def followers(client // @client, user_name) do
    client.request(:GET, "users/#{user_name}/followers")
  end

  @doc """
  returns if a user is following another user
  """
  def following?(client // @client, user_name, target_user) do
    client.request_status(:GET, "users/#{user_name}/following/#{target_user}") == 204
  end
end
