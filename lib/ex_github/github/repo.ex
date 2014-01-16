defmodule ExGithub.Repo do
  @client ExGithub.Client

  @doc """ 
  returns a list of repos for the given user
  """
  def fetch_repos(client // @client, user_name) do
    client.request(:get, "users/#{user_name}/repos")
  end

  @doc """ 
  returns a list of repos for the given org 
  """
  def fetch_org_repos(client // @client, org_name) do
    client.request(:get, "orgs/#{org_name}/repos")
  end
  
  @doc """
  returns a single repo and its attributes for a `owner` 
  """
  def fetch(client // @client, owner, repo) do
    client.request(:get, "repos/#{owner}/#{repo}")
  end

  @doc """
  returns the current autenticated users repos
  """
  def repos(client // @client, auth_token) do
    client.request(client.http_library, :get, "user/repos", auth_token: auth_token)
  end

  @doc """
  updates a repo with `values` and return the new repo
  """
  def update(client // @client, auth_token, owner, repo, values) do
    client.patch(client.http_library, "repos/#{owner}/#{repo}", values, auth_token: auth_token)
  end
end

