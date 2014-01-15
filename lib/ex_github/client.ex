defmodule ExGithub.Client do
  use    GenServer.Behaviour
  @endpoint_url "https://api.github.com"

  @doc """
  returns the full URL depending on path

  ## Examples
    iex> ExGithub.Client.api_url("users/ortuna")
    "https://api.github.com/users/ortuna"
  """
  def api_url(path) do
    "#{@endpoint_url}/#{path}"
  end

  @doc """
  returns a JSON decoded output from a specified URL
  """
  def request(library // HTTPotion, :GET, path, headers // []) do 
    api_url(path)
      |> library.get(request_headers(headers))
      |> json_from_response
  end
  
  def json_from_response(HTTPotion.Response[body: body]) do
    {:ok, hash} = JSON.decode(body)
    hash
  end

  def request_headers(headers // []) do
    [{"User-Agent", "ExGithub"}] ++ headers 
  end

  #PRIVATE
end
