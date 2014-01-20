defmodule ExGithub.Repo.Tree do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch, "repos/:owner/:repo/git/trees/:sha")
  get_json(:fetch_recursive, "repos/:owner/:repo/git/trees/:sha?recursive=true")
end
