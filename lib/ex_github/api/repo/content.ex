defmodule ExGithub.Repo.Content do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:readme, "repos/:owner/:repo/readme")
  get_json(:fetch, "repos/:owner/:repo/contents/:path")
  get_request(:fetch_content, "repos/:owner/:repo/contents/:path", fn(res) ->
    {:ok, json} = JSON.decode(res.body)
    Dict.put(json, "decoded_content", :base64.decode(json["content"]))
  end)

  put_values([:add, :create], "repos/:owner/:repo/contents/:path")
  put_values(:update, "repos/:owner/:repo/contents/:path")
  del(:remove, "repos/:owner/:repo/contents/:path")

end
