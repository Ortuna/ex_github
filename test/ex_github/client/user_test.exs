defmodule UserTest do
  use    ExUnit.Case, async: false
  alias  ExGithub.Client
  import ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/http")
    :ok
  end

  test "can return JSON from a request" do
    use_cassette "ortuna" do
      response = Client.user(Client.create, "ortuna")
      assert response["login"]        == "Ortuna"
      assert response["id"]           == 221008
      assert response["public_repos"] == 57
    end
  end


end
