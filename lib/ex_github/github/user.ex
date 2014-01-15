defmodule ExGithub.User do
  @client ExGithub.Client

  @doc """
  returns a users details
  """
  def fetch(client // @client, user_name) do
    client.request(:get, "users/#{user_name}")
  end

  @doc """
  returns the current authenticated user
  """
  def user(client // @client, auth_token) do
    client.request(client.http_library, :get, "user", auth_token: auth_token)
  end

  @doc """
  Updates the current authenticated user using `values`
  and returns the updated user
  """
  def update(client // @client, auth_token, values) do
    client.patch(client.http_library, "user", values, auth_token: auth_token)
  end
  
  @doc """
  returns a list of the current users emails
  """
  def emails(client // @client, auth_token) do
    client.request(client.http_library, :get, "user/emails", auth_token: auth_token)
  end

  @doc """
  returns a list of followers for a particular user
  """
  def followers(client // @client, user_name) do
    client.request(:get, "users/#{user_name}/followers")
  end

  @doc """
  returns if a user is following another user
  """
  def following?(client // @client, user_name, target_user) do
    client.request_status(:get, "users/#{user_name}/following/#{target_user}") == 204
  end

  @doc """
  request current user follow another user
  """
  def follow(client // @client, auth_token, target_user) do
    _follow(client, auth_token, target_user, :put) == 204
  end

  @doc """
  request current user unfollow another user
  """
  def unfollow(client // @client, auth_token, target_user) do
    _follow(client, auth_token, target_user, :delete) == 204
  end

  #PRIVATE
  defp _follow(client, auth_token, target_user, verb) do
    args = [ client.http_library, "user/following/#{target_user}",auth_token: auth_token ]
    apply(client, verb, args)
  end
  
end
