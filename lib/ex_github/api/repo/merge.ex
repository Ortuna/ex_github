defmodule ExGithub.Repo.Merge do
  use ExGithub.DSL, client: ExGithub.Client

  post(:perform, "repos/:owner/:repo/merges")
end
