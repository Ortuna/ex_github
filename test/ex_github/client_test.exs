defmodule ClientTest do
  use    ExUnit.Case, async: true

  alias  ExGithub.Client
  import ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/http")
    :ok
  end

  test "Can create a new client" do
    assert is_pid(Client.create) == true
  end

  test "can create a new client with an auth_token" do
    assert is_pid(Client.create(auth_token: "some_token")) == true
  end

  test "knows it's auth_token" do
    client = Client.create(auth_token: "some_token")
    assert Client.auth_token(client) == "some_token"
  end

  test "can make a remote request" do
    use_cassette "plain" do
      response = Client._get(Client.create, "https://api.github.com")
      assert response == "expected body"
    end
  end

  test "can return JSON from a request" do
    use_cassette "plain" do
      response = Client._request(Client.create, :GET, "simple_object")
      assert response["field"] == 1234
    end
  end

  test "can parse JSON" do
    json = """
    {
      "field":  "value",
      "field2": "value2"
    }
    """

    response = Client._parse_json(json)
    assert response["field"]  == "value"
    assert response["field2"] == "value2"
  end

end
