defmodule ExGithub.Repo do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch_all, "users/:user/repos")
  get_json(:fetch_user, "user/repos")
  get_json(:fetch_org, "orgs/:org/repos")
  get_json(:fetch, "repos/:owner/:repo")

  post(:create, "user/repos")
  post(:create_in_org, "orgs/:org/repos")
  patch(:update, "repos/:owner/:repo")

  get_json(:contributors, "repos/:owner/:repo/contributors")
  get_json(:languages, "repos/:owner/:repo/languages")
  get_json(:tags, "repos/:owner/:repo/tags")
  
  del(:delete, "repos/:owner/:repo")
end
