defmodule ExGithubCollabTest do
  use    ExUnit.Case, async: false
  alias  ExGithub.Collaborator
  import ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/http/collaborator")
    :ok
  end

  test "can get a list of collaborators" do
    use_cassette "collaborators" do
      branches = Collaborator.fetch_all("elixir-lang", "elixir")
      first    = Enum.at(branches, 0)

      assert Enum.count(branches) == 5
      assert first["login"] == "alco"
    end
  end

  test "can get if a user is a collaborator" do
    use_cassette "is_collaborator" do
      refute Collaborator.is_collaborator?("elixir-lang", "elixir", "ortuna")
      assert Collaborator.is_collaborator?("elixir-lang", "elixir", "josevalim")
    end
  end

  test "can delete a user as a collaborator" do
    use_cassette "delete" do
      assert Collaborator.delete("auth_token", "elixir-lang", "elixir", "ortuna")
    end
  end

  test "can add a user as a collaborator" do
    use_cassette "add" do
      assert Collaborator.add("auth_token", "elixir-lang", "elixir", "ortuna")
    end
  end

end
