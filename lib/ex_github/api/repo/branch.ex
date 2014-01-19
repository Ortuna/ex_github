defmodule ExGithub.Repo.Branch do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch_all, "repos/:owner/:repo/branches")
  get_json(:fetch, "repos/:owner/:repo/branches/:branch")

end 
