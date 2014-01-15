defmodule ClientMocks do
  defmodule SimpleGETJSON do
    def get(_url, _headers) do
      body = "{\"field\": \"value\", \"field2\": \"value2\"}"
      HTTPotion.Response.new([status_code: 200, body: body])
    end
  end

  defmodule ExplicitParams do
    def get("https://api.github.com/users/Ortuna", headers) do
      body = "{\"field\": \"#{Dict.get(headers, "field")}\"}"
      HTTPotion.Response.new([status_code: 200, body: body])
    end

    def get("https://api.github.com/auth_token", headers) do
      body = "{\"auth_token\": \"#{Dict.get(headers, "Authorization")}\"}"
      HTTPotion.Response.new([status_code: 200, body: body])
    end
  end
  
  def default_header do
    [{"User-Agent", "ExGithub"}]
  end
end

defmodule ClientTest do
  use     ExUnit.Case, async: true
  alias   ExGithub.Client
  doctest Client
  
  def create_response(status_code // 200, body) do 
    HTTPotion.Response.new([status_code: status_code, body: body])
  end

  test "can GET JSON from a path" do
    output = Client.request(ClientMocks.SimpleGETJSON, :GET, "users/Ortuna") 
    assert output["field"]  == "value"
    assert output["field2"] == "value2"
  end
  
  test "sends the right headers to a request" do
    headers = [{"field", "passed value"}]
    output = Client.request(ClientMocks.ExplicitParams, :GET, "users/Ortuna", headers: headers) 
    assert output["field"]  == "passed value"
  end
  
  test "sends the right auth_toke to a request" do
    output = Client.request(ClientMocks.ExplicitParams, :GET, "auth_token", auth_token: "1234abc") 
    assert output["auth_token"]  == "token 1234abc"
  end

  test "#json_from response can parse JSON from a HTTPotion.Response" do
    response = create_response("{\"field\": \"value\", \"field2\": \"value2\"}") 
    output   = Client.json_from_response(response)
    assert output["field"]  == "value"
    assert output["field2"] == "value2"
  end
  
  test "#request_headers appends user-agent to headers" do
    headers  = Client.request_headers
    assert headers == ClientMocks.default_header

    headers  = Client.request_headers(nil, [{"X-YZ", "some_value"}])
    expected = ClientMocks.default_header ++ [{"X-YZ", "some_value"}]
    assert headers == expected
  end

  test "#request_headers appends auth_token to returned headers" do
    headers = Client.request_headers("123446asdbc0000")
    assert Dict.get(headers, "Authorization") == "token 123446asdbc0000"

    headers = Client.request_headers
    assert headers == ClientMocks.default_header
  end

  test "#status_from_response can return the status from a request" do
    response = create_response(404, "") 
    assert Client.status_from_response(response) == 404

    response = create_response(200, "") 
    assert Client.status_from_response(response) == 200
  end

end
