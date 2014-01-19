defmodule DSLTest do
  use ExUnit.Case

  defmodule Mock.Client do
    def get(HTTPotion, "users/:user", _options), do: "expected"
    def get_status(HTTPotion, "users/:user", _options), do: 200
    def get_json(HTTPotion, "users/:user", _options) do
      HashDict.new([{"field", "value"}])
    end
    def get_request(HTTPotion, "users/:user", _options) do
      HTTPotion.Response.new(status_code: 204)
    end
    def delete(HTTPotion, "users/:user", _options), do: 204
    def put(HTTPotion, "users/:user", _options), do: 204
    def patch(HTTPotion, "users/:user", values, _options) do
      HashDict.new([{"field", values[:field]}])
    end


    def http_library, do: HTTPotion
  end 

  defmodule TestEntity do
    use ExGithub.DSL, client: Mock.Client 

    get(:fetch, "users/:user")
    get_status(:fetch_status, "users/:user")
    get_json(:fetch_json, "users/:user")
    get_request(:fetch_raw, "users/:user", fn (response)->
      response.status_code == 204
    end)

    del(:delete, "users/:user")
    put(:add, "users/:user")
    patch(:update, "users/:user")

  
  end

  test "get requests" do
    output = TestEntity.fetch(user: "some_user")
    assert output == "expected" 
  end
  
  test "get_request requests" do
    output = TestEntity.fetch_raw(user: "some_user")
    assert output == true
  end

  test "get_status requests" do
    status = TestEntity.fetch_status(user: "some_user")
    assert status == 200
  end

  test "get_json requests" do
    entity = TestEntity.fetch_json(user: "some_user")
    assert entity["field"] == "value"
  end

  test "delete requests" do
    status = TestEntity.delete(user: "some_user")
    assert status == 204
  end

  test "put requests" do
    status = TestEntity.add(user: "new_user") 
    assert status == 204
  end

  test "patch requests" do
    entity = TestEntity.update([field: "value"], user: "new_user") 
    assert entity["field"] == "value"
  end

end
