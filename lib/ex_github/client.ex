defmodule ExGithub.Client do
  @endpoint_url "https://api.github.com"
  @library      HTTPotion

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
  Takes a Keyword list as the input JSON
  returns a JSON decoded output from a PATCH request.
  """
  def patch(library // @library, path, keyword_list, options // []) do 
    {:ok, body} = JSON.encode(keyword_list)
    library.patch(api_url(path), body, headers_from_options(options))
     |> json_from_response
  end

  @doc """
  returns a JSON decoded output from a PUT request.
  """
  def put(library // @library, path, options // []) do 
    _empty_body_status_request(library, :put, path, options)
  end

  @doc """
  returns a JSON decoded output from a DELETE request.
  """
  def delete(library // @library, path, options // []) do 
    request_status(library, :delete, path, options)
  end

  defp _empty_body_status_request(library, verb, path, options) do
    args = [api_url(path), "", headers_from_options(options)]
    apply(library, verb, args)
     |> status_from_response
  end

  @doc """
  returns a JSON decoded output from a specified URL
  """
  def request(library // @library, verb, path, options // []) do 
    make_request(verb, library, path, options)
      |> json_from_response
  end
  
  @doc """
  returns the status code returned by the HTTP call
  """
  def request_status(library // @library, verb, path, options // []) do
    make_request(verb, library, path, options)
     |> status_from_response
  end

  @doc """
  returns decoded JSON from a HTTPotion.Response
  """
  def json_from_response(@library.Response[body: body]) do
    {:ok, hash} = JSON.decode(body)
    hash
  end

  @doc """
  returns the status code from a HTTPotion.Response
  """
  def status_from_response(@library.Response[status_code: code]), do: code

  def request_headers(auth_token // nil, headers // nil) do
    [{"User-Agent", "ExGithub"}] 
     ++ (auth_token_header(auth_token) || [])
     ++ (headers || [])
  end

  @doc """
  returns the default HTTP library used
  """
  def http_library do
    @library
  end

  #PRIVATE
  defp auth_token_header(nil), do: []
  defp auth_token_header(auth_token) do
    [{"Authorization", "token #{auth_token}"}]
  end

  defp make_request(verb, library, path, options) do
    apply(library, verb, [api_url(path), headers_from_options(options)])
  end

  defp headers_from_options(options) do
    headers = Keyword.get(options, :headers)
    token   = Keyword.get(options, :auth_token)
    request_headers(token, headers)
  end
end
