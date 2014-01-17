defmodule ExGithub.Collaborator do
  @client ExGithub.Client

  @doc """ 
  returns a list of repos for the given user
  """
  def fetch_all(client // @client, owner, repo) do
    client.request(:get, "repos/#{owner}/#{repo}/collaborators")
  end

  @doc """ 
  check if user is a collaborator on a repo
  """
  def is_collaborator?(client // @client, owner, repo, user) do
    client.request_status(:get, "repos/#{owner}/#{repo}/collaborators/#{user}") == 204
  end

  @doc """
  adds a collaborator to a repo
  """
  def add(client // @client, auth_token, owner, repo, user) do
    client.put(client.http_library, "repos/#{owner}/#{repo}/collaborators/#{user}", auth_token: auth_token)
    == 204
  end

  @doc """
  deletes a collaborator to a repo
  """
  def delete(client // @client, auth_token, owner, repo, user) do
    client.delete(client.http_library, "repos/#{owner}/#{repo}/collaborators/#{user}", auth_token: auth_token)
    == 204
  end
end
