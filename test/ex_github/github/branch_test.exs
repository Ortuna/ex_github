defmodule Mock.Branch do
  def http_library, do: HTTPotion

  def request(:get, "repos/some_owner/some_repo/branches/dev") do
    HashDict.new([{"name", "dev"}])
  end 

  def request(:get, "repos/some_owner/some_repo/branches") do 
    [ HashDict.new([{"name", "master"}]), 
      HashDict.new([{"name", "dev"}]), 
      HashDict.new([{"name", "other"}]) ] 
  end
end

defmodule BranchTest do
  use     ExUnit.Case, async: true
  alias   ExGithub.Branch

  test "can get a list branches" do
    branches = Branch.fetch_all(Mock.Branch, "some_owner", "some_repo")
    first    = Enum.at(branches, 0)

    assert Enum.count(branches) == 3
    assert first["name"] == "master"
  end

  test "can get a branch" do
    branch = Branch.fetch(Mock.Branch, "some_owner", "some_repo", "dev")
    assert branch["name"] == "dev"
  end
end
