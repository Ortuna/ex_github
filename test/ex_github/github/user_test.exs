defmodule UserMocks do
  defmodule Ortuna do
    def request(:GET, "users/ortuna") do
      HashDict.new([ {"login", "Ortuna"}, {"id", 42} ])
    end

    def request(:GET, "users/ortuna/followers") do
      [ HashDict.new([ {"login", "smart_guy"}, {"id", 1} ]),
        HashDict.new([ {"login", "smart_gal"}, {"id", 2} ]) ]
    end
    
    def request_status(:GET, "users/ortuna/following/elixir"), do: 204
    def request_status(:GET, "users/ortuna/following/php"),    do: 404

  end
end

defmodule UserTest do
  use     ExUnit.Case, async: true
  alias   ExGithub.User
  doctest User
  
  test "can fetch a user" do
    user = User.fetch(UserMocks.Ortuna, "ortuna")
    assert user["login"] == "Ortuna"
    assert user["id"]    == 42
  end

  test "can fetch followers" do
    followers = User.followers(UserMocks.Ortuna, "ortuna")
    assert Enum.count(followers) == 2

    first = Enum.first(followers) 
    assert first["login"] == "smart_guy"
    assert first["id"]    == 1
  end

  test "following status" do
    assert User.following?(UserMocks.Ortuna, "ortuna", "elixir") == true 
    assert User.following?(UserMocks.Ortuna, "ortuna", "php")    == false
  end
end
