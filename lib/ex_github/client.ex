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
  def request(library // HTTPotion, :GET, path, options // []) do 
    make_get_request(library, path, options)
      |> json_from_response
  end
  
  @doc """
  returns the status code returned by the HTTP call
  """
  def request_status(library // HTTPotion, :GET, path, options // []) do
    make_get_request(library, path, options)
     |> status_from_response
  end

  @doc """
  returns decoded JSON from a HTTPotion.Response
  """
  def json_from_response(HTTPotion.Response[body: body]) do
    {:ok, hash} = JSON.decode(body)
    hash
  end

  @doc """
  returns the status code from a HTTPotion.Response
  """
  def status_from_response(HTTPotion.Response[status_code: code]), do: code

  def request_headers(auth_token // nil, headers // []) do
    [{"User-Agent", "ExGithub"}] 
     ++ auth_token_header(auth_token) 
     ++ headers 
  end

  #PRIVATE
  defp auth_token_header(nil), do: []
  defp auth_token_header(auth_token) do
    [{"Authorization", "token #{auth_token}"}]
  end

  defp make_get_request(library, path, options) do
    headers = Keyword.get(options, :headers)
    token   = Keyword.get(options, :auth_token) || []
    api_url(path)
     |> library.get(request_headers(token, headers))
  end
end
