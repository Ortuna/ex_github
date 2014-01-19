defmodule ExGithub.Repo.Commit do
  use ExGithub.DSL, client: ExGithub.Client
  
  get_json(:fetch_all, "repos/:owner/:repo/commits")
  get_json(:fetch, "repos/:owner/:repo/commits/:sha")
  get_json(:compare, "repos/:owner/:repo/compare/:base...:head")
end
