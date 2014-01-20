defmodule ExGithub.Repo.Merge do
  use ExGithub.DSL, client: ExGithub.Client

  post([:create, :add, :perform], "repos/:owner/:repo/merges")
end
