defmodule ExGithub.Branch do 
  @client ExGithub.Client

  @doc """
  returns a list of branches for a repo
  """
  def fetch_all(client // @client, owner, repo) do
    client.request(:get, "repos/#{owner}/#{repo}/branches")
  end

  @doc """
  returns a branch for a repo
  """
  def fetch(client // @client, owner, repo, branch) do
    client.request(:get, "repos/#{owner}/#{repo}/branches/#{branch}")
  end
end

