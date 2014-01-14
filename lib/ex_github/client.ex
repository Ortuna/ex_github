defmodule ExGithub.Client do
  use GenServer.Behaviour
  use ExGithub.User

  @endpoint_url "https://api.github.com"

  def create do
    start_link
  end 

  def create([{:auth_token, auth_token}]) do
    start_link(auth_token)
  end

  def auth_token(client) do
    :gen_server.call(client, :auth_token)
  end

  #PRIVATE API
  def _get(client, url) do
    HTTPotion.get(url, []).body
  end

  def _request(client, verb, path) do
    url = api_url(client, path) 
    case verb do  
      :GET ->
        _get(client, url)
          |> _parse_json
      :POST ->
        _get(client, url)
      _ ->
        _get(client, url)
    end
  end

  def _parse_json(string) do
    {:ok, json} = JSON.decode(string)
    json
  end

  def handle_call(:auth_token, _from, config) do
    {:reply, config[:auth_token], config}
  end

  defp start_link(auth_token // nil) do
    {:ok, pid} = :gen_server.start_link(__MODULE__, [auth_token: auth_token], [])
    pid
  end 

  defp api_url(_client, path) do
    "#{@endpoint_url}/#{path}"
  end

end
