defmodule ExGithubBranchTest do
  use    ExUnit.Case, async: false
  alias  ExGithub.Branch
  import ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/http/repo")
    :ok
  end

  test" can get a list of branches" do
    use_cassette "branches" do
      branches = Branch.fetch_all("elixir-lang", "elixir")
      first    = Enum.at(branches, 0)
      assert Enum.count(branches) == 2
      assert first["name"] == "master"
    end
  end

  test "can get a branch" do
    use_cassette "branch" do
      branch = Branch.fetch("elixir-lang", "elixir", "stable")
      assert branch["name"] == "stable"
    end
  end
end
