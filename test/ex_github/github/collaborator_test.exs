defmodule Mock.Collaborator do
  def request(:get, "repos/some_owner/some_repo/collaborators") do
    [ HashDict.new([{"login", "elixir"}]), 
      HashDict.new([{"login", "user1"}]), 
      HashDict.new([{"login", "user2"}]) ]
  end

  def request_status(:get, "repos/some_owner/some_repo/collaborators/elixir"), do: 204
  def request_status(:get, "repos/some_owner/some_repo/collaborators/php"), do: 404 

  def put(HTTPotion, "repos/some_owner/some_repo/collaborators/elixir", auth_token: "auth_token"), do: 204
  def delete(HTTPotion, "repos/some_owner/some_repo/collaborators/elixir", [auth_token: "auth_token"]), do: 204
  def http_library, do: HTTPotion 
end

defmodule CollaboratorTest do
  use    ExUnit.Case, async: true
  alias  ExGithub.Collaborator
  
  test "can get a list of collaborators" do
    users = Collaborator.fetch_all(Mock.Collaborator, "some_owner", "some_repo")
    first = Enum.at(users, 0)

    assert Enum.count(users) == 3
    assert first["login"]    == "elixir"
  end

  test "can get if a user is a collaborator on a repo" do
    assert Collaborator.is_collaborator?(Mock.Collaborator, "some_owner", "some_repo", "elixir")
    refute Collaborator.is_collaborator?(Mock.Collaborator, "some_owner", "some_repo", "php")
  end

  test "can add a collaborator to a repo" do
    assert Collaborator.add(Mock.Collaborator, "auth_token", "some_owner", "some_repo", "elixir")
  end

  test "can delete a collaborator to a repo" do
    assert Collaborator.delete(Mock.Collaborator, "auth_token", "some_owner", "some_repo", "elixir")
  end
end
