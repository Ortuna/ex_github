defmodule ExGithub.Repo.Comment do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch_all, "repos/:owner/:repo/comments")
  get_json(:fetch, "repos/:owner/:repo/commits/:sha/comments")
  get_json(:fetch_by_id, "repos/:owner/:repo/comments/:id")
  patch(:update, "repos/:owner/:repo/comments/:id")
  del(:remove, "repos/:owner/:repo/comments/:id")
  post(:add, "repos/:owner/:repo/commits/:sha/comments")

end
