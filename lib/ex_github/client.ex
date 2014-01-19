defmodule ExGithub.Client do
  @base_url "https://api.github.com"
  @http_library HTTPotion

  def get(http, path, options // []) do 
    _get(http, path, options)
      |> extract_body
  end

  def get_json(http, path, options // []) do
    _get(http, path, options)
      |> extract_json
  end
  
  def get_request(http, path, options// []) do
    _get(http, path, options)
  end

  def get_status(http, path, options // []) do
    _get(http, path, options)
      |> extract_status
  end

  def delete(http, path, options // []) do
    _request(:delete, http, path, options)
      |> extract_status
  end

  def put(http, path, options // []) do
    _request(:put, http, path, options)
      |> extract_status
  end

  def patch(http, path, values, options // []) do
    {:ok, json} = JSON.encode(values)
    _request(:patch, http, path, json, options) 
      |> extract_json
  end

  def parse_headers(options) do
    default_headers 
      |> Keyword.merge(create_headers(options) || [])
      |> Keyword.merge(options)
  end

  def parse_path(path, options) do
    Enum.reduce(options, path, fn({key, value}, acc) ->
      String.replace(acc, ":#{key}", value)
    end)
  end

  def parse_url(path) do
    "#{@base_url}/#{path}"
  end

  def extract_body(@http_library.Response[body: body]), do: body
  def extract_status(@http_library.Response[status_code: status_code]), do: status_code
  def extract_json(@http_library.Response[body: body]) do
    {:ok, hash} = JSON.decode(body)
    hash
  end

  def http_library, do: @http_library

  #PRIVATE
  defp _request(verb, http, path, body // "", options) do
    url = parse_path(path, options)
           |> parse_url
    http.request(verb, url, body, parse_headers(options), [])
  end

  defp _get(http, path, options) do
    parse_path(path, options)
      |> parse_url
      |> http.get(parse_headers(options))
  end

  defp create_headers(options) do
    (options[:auth_token]  && ["Authorization": "token #{options[:auth_token]}"])
  end

  defp default_headers do
    ["User-Agent": "ExGithub"]
  end
end
