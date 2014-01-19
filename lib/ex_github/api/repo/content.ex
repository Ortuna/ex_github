defmodule ExGithub.Repo.Content do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:readme, "repos/:owner/:repo/readme")
  get_json(:fetch, "repos/:owner/:repo/contents/:path")

  put_values(:add, "repos/:owner/:repo/contents/:path")
  put_values(:update, "repos/:owner/:repo/contents/:path")
  del(:remove, "repos/:owner/:repo/contents/:path")

end
