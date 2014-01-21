defmodule ExGithub.Repo.Hook do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch_all, "repos/:owner/:repo/hooks")
  get_json(:fetch, "repos/:owner/:repo/hooks/:id")
  post([:add, :create], "repos/:owner/:repo/hooks")
  del(:remove, "repos/:owner/:repo/hooks/:id")
  patch(:update, "repos/:owner/:repo/hooks/:id")
  post(:test, "repos/:owner/:repo/hooks/:id/tests")
end
