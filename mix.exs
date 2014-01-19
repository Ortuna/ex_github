defmodule ExGithub.Mixfile do
  use Mix.Project

  def project do
    [ app: :ex_github,
      version: "0.0.1",
      elixir: "~> 0.12.0",
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:ssl, :httpotion],
      mod: { ExGithub, [] } ]
  end

  defp deps(:test) do
    deps(:dev) ++ 
    [ {:exvcr, github: "parroty/exvcr"} ]
  end

  defp deps(:prod) do
    [ {:json,      github: "cblage/elixir-json"},
      {:httpotion, github: "myfreeweb/httpotion"} ]
  end
  
  defp deps(_env) do
    deps(:prod)
  end
end
