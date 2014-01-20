defmodule ExGithub.Repo.DeployKey do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch_all, "repos/:owner/:repo/keys")    
  get_json(:fetch, "repos/:owner/:repo/keys/:id")    
  post([:add, :create], "repos/:owner/:repo/keys") 
  patch(:update, "repos/:owner/:repo/keys/:id")
  del(:remove, "repos/:owner/:repo/keys/:id")
end
