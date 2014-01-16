defmodule ExGithubUserTest do
  use    ExUnit.Case, async: false
  alias  ExGithub.User
  import ExVCR.Mock

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/http")
    :ok
  end

  def is_ortuna(user) do
    assert user["login"]        == "Ortuna"
    assert user["id"]           == 221008
    assert user["public_repos"] == 57
  end

  test "can fetch a user" do
    use_cassette "ortuna" do
      assert is_ortuna(User.fetch("ortuna"))
    end
  end

  test "can fetch a users followers" do
    use_cassette "ortuna_followers" do
      followers = User.followers("ortuna") 
      assert Enum.count(followers) == 11
    end
  end

  test "can fetch if the user is following" do
    use_cassette "ortuna_following" do
      assert User.following?("ortuna", "php")    == false
      assert User.following?("ortuna", "elixir") == true 
    end
  end
  
  test "can follow a user" do
    use_cassette "ortuna_follow_unfollow" do
      assert User.follow("tokenabc12345", "elixir")
    end
  end

  test "can unfollow a user" do
    use_cassette "ortuna_follow_unfollow" do
      assert User.unfollow("tokenabc12345", "php")
    end
  end

  test "can get a users email addresses" do
    use_cassette "ortuna_emails" do
      emails = User.emails("tokenabc12345")
      assert Enum.count(emails) == 2
      assert Enum.at(emails, 0) == "ortuna@gmail.com"
    end
  end

  test "can fetch the logged in user" do
    use_cassette "ortuna_user" do
      assert is_ortuna(User.user("tokenabc12345"))
    end
  end

  test "can update the logged in user" do
    use_cassette "ortuna_update" do
      user = User.update("tokenabc12345", company: "test")
      assert user["company"] == "test"
    end
  end
end
