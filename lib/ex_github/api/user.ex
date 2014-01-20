defmodule ExGithub.User do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:fetch, "users/:user")
  get_json(:current, "user")
  patch(:update, "user")
  get_json(:emails, "user/emails")
  get_json(:followers, "users/:user/followers")
  get_request(:is_following?, "users/:user/following/:target_user", fn(response) ->
    response.status_code == 204
  end)
  put(:follow, "user/following/:user")
  del(:unfollow, "user/following/:user")
end
