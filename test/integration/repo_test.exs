defmodule ExGithubRepoTest do
  use    ExUnit.Case, async: false
  alias  ExGithub.Repo
  import ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/http/repo")
    :ok
  end

  test "can fetch a users repos" do
    use_cassette "user_repos" do
      repos = Repo.fetch_all("ortuna")
      assert Enum.count(repos) == 30
    end
  end

  test "can fetch an orgs repos" do
     use_cassette "org_repos" do
      repos = Repo.fetch_org_repos("elixir-lang")
      assert Enum.count(repos) == 9
    end
  end

  test "can fetch a single repo" do
    use_cassette "repo" do
      repo = Repo.fetch("ortuna", "ex_github")
      assert repo["full_name"] == "Ortuna/ex_github"
    end
  end

  test "can get a list of contributors" do
    use_cassette "contributors" do
      contributors = Repo.contributors("elixir-lang", "elixir")
      assert Enum.count(contributors) == 129
    end
  end

  test "can get a list of languages" do
    use_cassette "languages" do
      languages = Repo.languages("elixir-lang", "elixir")
      assert Enum.count(languages) == 3
    end
  end

  test "can get a list of tags" do
    use_cassette "tags" do
      tags = Repo.tags("elixir-lang", "elixir")
      assert Enum.count(tags) == 23
    end
  end

  test "can get the authenticated users repos" do
    use_cassette "repos" do
      repos = Repo.repos("auth_token")
      assert Enum.count(repos) == 30
    end
  end

  test "can update a repo" do
    use_cassette "update_repo" do
      new_repo = Repo.update("auth_token", "ortuna", "bana", name: "bana_new")
      assert new_repo["name"] == "bana_new"
    end
  end 

  test "can get a list of forks" do
    use_cassette "forks" do
      forks = Repo.forks("elixir-lang", "elixir")
      assert Enum.count(forks) == 30
    end
  end

end


