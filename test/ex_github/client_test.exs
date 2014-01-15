defmodule ClientMocks do
  defmodule SimpleGETJSON do
    def get(_url, _headers) do
      body = "{\"field\": \"value\", \"field2\": \"value2\"}"
      HTTPotion.Response.new([status_code: 200, body: body])
    end
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

  test "#json_from response can parse JSON from a HTTPotion.Response" do
    response = create_response("{\"field\": \"value\", \"field2\": \"value2\"}") 
    output   = Client.json_from_response(response)
    assert output["field"]  == "value"
    assert output["field2"] == "value2"
  end
  
  test "#request_headers appends user-agent to headers" do
    headers  = Client.request_headers
    expected = [{"User-Agent", "ExGithub"}]
    assert headers == expected

    headers  = Client.request_headers([{"X-YZ", "some_value"}])
    expected = [{"User-Agent", "ExGithub"}, {"X-YZ", "some_value"}]
    assert headers == expected
  end

  test "#status_from_response can return the status from a request" do
    response = create_response(404, "") 
    assert Client.status_from_response(response) == 404

    response = create_response(200, "") 
    assert Client.status_from_response(response) == 200
  end

end
