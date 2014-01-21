defmodule ExGithub.Mixfile do
  use Mix.Project

  def project do
    [ app: :ex_github,
      version: "0.1.0",
      elixir: "~> 0.12.2",
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:ssl, :httpotion],
      mod: { ExGithub, [] } ]
  end

  defp deps(:test) do
    deps(:dev) ++ 
    [ {:exvcr, github: "parroty/exvcr", branch: "master"} ]
  end

  defp deps(:prod) do
    [ {:json,      github: "cblage/elixir-json"},
      {:httpotion, github: "myfreeweb/httpotion"} ]
  end
  
  defp deps(_env) do
    deps(:prod)
  end
end
