defmodule ExGithub.Misc do
  use ExGithub.DSL, client: ExGithub.Client

  get_json(:rate_limit, "rate_limit")
  get_json(:emojis, "emojis")

  get_json(:git_ignore_templates, "gitignore/templates")
  get_json(:git_ignore, "gitignore/templates/:type")

  post(:mark_down, "markdown")
  get_json(:meta, "meta")
end
