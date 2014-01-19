defmodule ClientTest do
  use       ExUnit.Case
  alias     ExGithub.Client

  defmodule Mock do
    def get("https://api.github.com/users/some_user", _options) do
      HTTPotion.Response.new(status_code: 200, body: "expected body")
    end

    def get("https://api.github.com/repos/some_repo", _options) do
      json = "{\"field\": \"expected value\"}"
      HTTPotion.Response.new(status_code: 200, body: json)
    end

    def request(:delete, "https://api.github.com/users/some_user/repos/some_repo", _, _, _) do
      HTTPotion.Response.new(status_code: 204)
    end

    def request(:put, "https://api.github.com/users/some_user/repos/some_repo", _, _, _) do
      HTTPotion.Response.new(status_code: 204)
    end

    def request(:patch, "https://api.github.com/users/some_user", body, _, _) do 
      HTTPotion.Response.new(status_code: 200, body: body)
    end
  end

  test "parse a path" do
    path = Client.parse_path("users/:user", user: "some_user")
    assert path == "users/some_user"

    path = Client.parse_path("users/:user/repos/:repo", repo: "some_repo", user: "some_user")
    assert path == "users/some_user/repos/some_repo"

    path = Client.parse_path("users/:user/repos/:repo", user: "some_user")
    assert path == "users/some_user/repos/:repo"
  end

  test "parse a url" do
    url = Client.parse_url("some_url")
    assert url == "https://api.github.com/some_url"
  end

  test "adds Authorization to parsed headers" do
    headers = Client.parse_headers(auth_token: "abc1234")
    assert headers[:"Authorization"] == "token abc1234"
  end

  test "has a user-agent in the parsed headers" do
    headers = Client.parse_headers([])
    assert headers[:"User-Agent"] == "ExGithub"

    headers = Client.parse_headers("User-Agent": "AnotherAgent")
    assert headers[:"User-Agent"] == "AnotherAgent"
  end

  test "extracting body of a HTTPotion.Response" do
    response = HTTPotion.Response.new(status_code: 200, body: "output")
    assert Client.extract_body(response) == "output"
  end 

  test "extracting status code of a HTTPotion.Response" do
    response = HTTPotion.Response.new(status_code: 200, body: "output")
    assert Client.extract_status(response) == 200
  end

  test "extracting json from a HTTPotion.Response" do
    json     = "{\"field\": \"expected value\"}"
    response = HTTPotion.Response.new(status_code: 200, body: json)
    parsed   = Client.extract_json(response)
    assert parsed["field"] == "expected value"
  end

  #requests
  test "GET request" do
    response = Client.get(Mock, "users/:user", user: "some_user")
    assert response == "expected body"

    response = Client.get(Mock, "users/some_user")
    assert response == "expected body"
  end

  test "GET status request" do
    status_code = Client.get_status(Mock, "users/:user", user: "some_user")
    assert status_code == 200

    status_code = Client.get_status(Mock, "users/some_user")
    assert status_code == 200 
  end
  
  test "GET response request" do
    request = Client.get_request(Mock, "users/:user", user: "some_user")
    refute request.body == nil
    assert request.status_code == 200
  end

  test "GET json request" do
    json = Client.get_json(Mock, "repos/:repo", repo: "some_repo")
    assert json["field"] == "expected value"
  end

  test "DELETE request" do
    status = Client.delete(Mock, "users/:user/repos/:repo", user: "some_user", repo: "some_repo")
    assert status == 204
  end

  test "PUT request" do
    status = Client.put(Mock, "users/:user/repos/:repo",  user: "some_user", repo: "some_repo")
    assert status == 204
  end

  test "PATCH request" do
    output = Client.patch(Mock, "users/:user", [field: "my value"], user: "some_user")
    assert output["field"] == "my value"
  end

end
