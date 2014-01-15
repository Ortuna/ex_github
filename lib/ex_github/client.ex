defmodule ExGithub.Client do
  use    GenServer.Behaviour
  import ExGithub.User

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
    :gen_server.call(client, {:get, url})       
  end

  def _request(client, verb, path) do
    :gen_server.call(client, {:request, verb, path})
  end

  def _parse_json(string) do
    {:ok, json} = JSON.decode(string)
    json
  end

  def handle_call({:request, :GET, path}, _from, config) do
    url    = api_url(config[:endpoint_url], path) 
    {:reply, result, _config} = handle_call({:get, url}, _from, config)
    {:reply, _parse_json(result), config}
  end

  def handle_call({:get, url}, _from, config) do
    body = HTTPotion.get(url, []).body
    {:reply, body, config}
  end

  def handle_call({:api_url, path}, _from, config) do
    {:reply, "#{config[:endpoint_url]}/#{path}", config}
  end

  def handle_call(:auth_token, _from, config) do
    {:reply, config[:auth_token], config}
  end

  defp start_link(auth_token // nil) do
    config = [auth_token: auth_token, endpoint_url: @endpoint_url]
    {:ok, pid} = :gen_server.start_link(__MODULE__, config, [])
    pid
  end 

  defp api_url(endpoint_url, path) do
    "#{endpoint_url}/#{path}"  
  end

end
