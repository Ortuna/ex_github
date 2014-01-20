defmodule ExGithub.Repo.Blob do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch, "repos/:owner/:repo/git/blobs/:sha")
  post(:add, "repos/:owner/:repo/git/blobs")
end
