defmodule UserMocks do
  defmodule Ortuna do
    def request(:get, "users/ortuna") do
      HashDict.new([ {"login", "Ortuna"}, {"id", 42} ])
    end

    def request(:get, "users/ortuna/followers") do
      [ HashDict.new([ {"login", "smart_guy"}, {"id", 1} ]),
        HashDict.new([ {"login", "smart_gal"}, {"id", 2} ]) ]
    end

    def request(HTTPotion, :get, "user", [auth_token: "1234abc"]) do
      HashDict.new([ {"login", "Elixir"}, {"id", 99} ])
    end

    def request(HTTPotion, :get, "user/emails", [auth_token: "12345abc"]) do
      [ "example@gmail.com", "nsa@cia.com" ]
    end
   
    def request_status(:get, "users/ortuna/following/elixir"), do: 204
    def request_status(:get, "users/ortuna/following/php"),    do: 404
    def put(HTTPotion, "user/following/elixir", [auth_token: "12345abc"]), do: 204
    def put(HTTPotion, "user/following/php", [auth_token: "12345abc"]),    do: 404 
    def delete(HTTPotion, "user/following/php", [auth_token: "12345abc"]), do: 204 

    def patch(HTTPotion, "user", [company: "ortuna"], [auth_token: "12345abc"]) do
      HashDict.new([ {"company", "ortuna"}, {"id", 99} ])
    end

    def http_library, do: HTTPotion
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
  
  test "can fetch the current user" do
    user = User.user(UserMocks.Ortuna, "1234abc")
    assert user["login"] == "Elixir"
    assert user["id"]    == 99 
  end

  test "can update the current user" do
    updated_user = User.update(UserMocks.Ortuna, "12345abc", company: "ortuna")
    assert updated_user["company"] == "ortuna"
  end

  test "can fetch followers" do
    followers = User.followers(UserMocks.Ortuna, "ortuna")
    assert Enum.count(followers) == 2

    first = Enum.at(followers, 0) 
    assert first["login"] == "smart_guy"
    assert first["id"]    == 1
  end

  test "following status" do
    assert User.following?(UserMocks.Ortuna, "ortuna", "elixir") == true 
    assert User.following?(UserMocks.Ortuna, "ortuna", "php")    == false
  end

  test "follow a user" do
    assert User.follow(UserMocks.Ortuna, "12345abc", "elixir") == true
    assert User.follow(UserMocks.Ortuna, "12345abc", "php")    ==  false
  end

  test "unfollow a user" do
    assert User.unfollow(UserMocks.Ortuna, "12345abc", "php") == true
  end

  test "can fetch current users emails" do
    emails = User.emails(UserMocks.Ortuna, "12345abc")
    first  = Enum.at(emails, 0)
    assert Enum.count(emails) == 2
    assert first == "example@gmail.com"
  end
end
