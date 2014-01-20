defmodule ExGithub.Repo.Fork do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch_all, "repos/:owner/:repo/forks")
  post([:add, :create], "repos/:owner/:repo/forks")
end
