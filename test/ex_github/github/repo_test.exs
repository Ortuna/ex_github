defmodule Mock.Repo do
  def repo_list do
    [ HashDict.new([ {"id", 1}, {"name", "some_repo"},  {"full_name", "some_repo"} ]),
      HashDict.new([ {"id", 2}, {"name", "some_repo2"}, {"full_name", "some_repo2"} ])]
  end

  def request(:get, "users/some_user/repos"), do: repo_list
  def request(:get, "orgs/some_org/repos"),   do: repo_list
  def request(:get, "repos/some_owner/some_repo/contributors") do
    [ HashDict.new([{"id", 1}]), HashDict.new([{"id", 2}]), HashDict.new([{"id", 3}]) ] 
  end

  def request(:get, "repos/some_owner/some_repo/teams") do
    [ HashDict.new([{"name", "team1"}]), 
      HashDict.new([{"name", "team2"}]), 
      HashDict.new([{"name", "team3"}]) ] 
  end

  def request(:get, "repos/some_owner/some_repo/languages") do
    [ HashDict.new([{"C", 1501}]), 
      HashDict.new([{"python", 222}]), 
      HashDict.new([{"elixir", 3}]) ] 
  end

  def request(:get, "repos/some_owner/some_repo/tags") do
    [ HashDict.new([{"name", "v1.0"}]), 
      HashDict.new([{"name", "v2.0"}]), 
      HashDict.new([{"name", "v3.0"}]) ] 
  end

  def request(:get, "repos/some_owner/some_repo/branches") do 
    [ HashDict.new([{"name", "master"}]), 
      HashDict.new([{"name", "dev"}]), 
      HashDict.new([{"name", "other"}]) ] 
  end

  def request(:get, "repos/some_owner/some_repo/forks") do 
    [1, 2, 3]
  end

  def request(:get, "repos/some_owner/some_repo/branches/dev") do
    HashDict.new([{"name", "dev"}])
  end 

  def request(:get, "repos/some_user/some_repo"), do: Enum.at(repo_list, 0)
  def request(HTTPotion, :get, "user/repos", [auth_token: "auth_token"]), do: repo_list

  def patch(HTTPotion, "repos/some_user/some_repo", [name: "some_repo", hash_issues: false], [auth_token: "auth_token"]) do
    Enum.at(repo_list, 0)
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

  test "can get a list of contributors" do
    contributors = Repo.contributors(Mock.Repo, "some_owner", "some_repo")
    assert Enum.count(contributors) == 3 
  end

  test "can get a list of languages" do
    languages = Repo.languages(Mock.Repo, "some_owner", "some_repo")
    first     = Enum.at(languages, 0)
  
    assert Enum.count(languages) == 3
    assert first["C"] == 1501
  end

  test "can get a list of teams" do
    teams = Repo.teams(Mock.Repo, "some_owner", "some_repo")
    first = Enum.at(teams, 0)

    assert Enum.count(teams) == 3
    assert first["name"] == "team1"
  end

  test "can get a list of tags" do
    tags  = Repo.tags(Mock.Repo, "some_owner", "some_repo")
    first = Enum.at(tags, 0)

    assert Enum.count(tags) == 3
    assert first["name"] == "v1.0"
  end

  test "can get a list branches" do
    branches = Repo.branches(Mock.Repo, "some_owner", "some_repo")
    first    = Enum.at(branches, 0)


    assert Enum.count(branches) == 3
    assert first["name"] == "master"
  end

  test "can get a branch" do
    branch = Repo.branch(Mock.Repo, "some_owner", "some_repo", "dev")
    assert branch["name"] == "dev"
  end

  test "can get a list of forks" do
    forks = Repo.forks(Mock.Repo, "some_owner", "some_repo")
    assert Enum.count(forks) == 3
  end
end
