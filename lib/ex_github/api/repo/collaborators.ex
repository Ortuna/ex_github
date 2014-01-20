defmodule ExGithub.Repo.Collaborator do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch_all, "repos/:owner/:repo/collaborators")
  get_request(:is_collaborator?, "repos/:owner/:repo/collaborators/:user", fn(response) ->
    response.status_code == 204
  end)

  put([:add, :create], "repos/:owner/:repo/collaborators/:user")
  del(:remove, "repos/:owner/:repo/collaborators/:user")

end
