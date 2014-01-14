defmodule ExGithub do
  use Application.Behaviour

  def start(_type, _args) do
    ExGithub.Supervisor.start_link
  end
end
