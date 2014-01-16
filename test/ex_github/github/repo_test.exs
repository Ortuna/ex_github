defmodule Mock.Repo do
  def repo_list do
    [ HashDict.new([ {"id", 1}, {"name", "some_repo"},  {"full_name", "some_repo"} ]),
      HashDict.new([ {"id", 2}, {"name", "some_repo2"}, {"full_name", "some_repo2"} ]),]
  end

  def request(:get, "users/some_user/repos"), do: repo_list
  def request(:get, "orgs/some_org/repos"),   do: repo_list

  def request(:get, "repos/some_user/some_repo"), do: Enum.first(repo_list)
  def request(HTTPotion, :get, "user/repos", [auth_token: "auth_token"]), do: repo_list

  def patch(HTTPotion, "repos/some_user/some_repo", [name: "some_repo", hash_issues: false], [auth_token: "auth_token"]) do
    Enum.first(repo_list)
  end

  def http_library, do: HTTPotion 
end

defmodule RepoTest do
  use    ExUnit.Case, async: true
  alias  ExGithub.Repo
  
  def validate_repo_list(repos) do
    first = Enum.at(repos, 0)
    assert Enum.count(repos) == 2
    assert first["name"]     == "some_repo" 
    assert first["id"]       == 1
  end

  test "can fetch a users repositories" do
    repos = Repo.fetch_repos(Mock.Repo, "some_user") 
    validate_repo_list(repos)
  end

  test "can fetch a single repository" do
    repo = Repo.fetch(Mock.Repo, "some_user", "some_repo")
    assert repo["name"] == "some_repo"
    assert repo["id"]   == 1
  end

  test" can fetch the current users repos" do
    repos = Repo.repos(Mock.Repo, "auth_token") 
    validate_repo_list(repos)
  end
 
  test "can fetch a orgs repos" do
    repos = Repo.fetch_org_repos(Mock.Repo, "some_org")
    validate_repo_list(repos) 
  end
  
  test "can update a repo" do
    values = [name: "some_repo", hash_issues: false]
    repo   = Repo.update(Mock.Repo, "auth_token", "some_user", "some_repo", values)
    assert repo["name"] == "some_repo"
  end
end
