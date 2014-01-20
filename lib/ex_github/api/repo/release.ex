defmodule ExGithub.Repo.Release do
  use ExGithub.DSL, client: ExGithub.Client
  
  get_json(:fetch_all, "repos/:owner/:repo/releases")
  get_json(:fetch, "repos/:owner/:repo/releases/:id")

  post([:add, :create], "repos/:owner/:repo/releases")
  patch(:update, "repos/:owner/:repo/releases/:id")
  del(:remove, "repos/:owner/:repo/releases/:id")

  defmodule Asset do
    get_json(:fetch_all, "repos/:owner/:repo/releases/:id/assets")
    get_json(:fetch, "repos/:owner/:repo/releases/assets/:id")
    patch(:update, "repos/:owner/:repo/releases/assets/:id")
    del(:remove, "repos/:owner/:repo/releases/assets/:id")
  end
end
