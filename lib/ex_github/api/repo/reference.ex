defmodule ExGithub.Repo.Reference do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch, "repos/:owner/:repo/git/refs/:ref")
  get_json(:fetch_all, "repos/:owner/:repo/git/refs")
  get_json(:tags, "repos/:owner/:repo/git/refs/tags")

  post(:add, "repos/:owner/:repo/git/refs")
  patch(:update, "repos/:owner/:repo/git/refs/:ref")
  del(:remove, "repos/:owner/:repo/git/refs/:ref")
end
