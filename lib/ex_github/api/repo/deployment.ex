defmodule ExGithub.Repo.Deployment do
  use ExGithub.DSL, client: ExGithub.Client
  
  get_json(:fetch_all, "repos/:owner/:repo/deployments")
  post(:add, "repos/:owner/:repo/deployments")

  defmodule Status do
    get_json(:fetch_all, "repos/:owner/:repo/deployments/:id/statuses")
    post(:add, "repos/:owner/:repo/deployments/:id/statuses")
  end
end
