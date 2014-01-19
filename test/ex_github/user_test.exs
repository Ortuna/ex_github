defmodule UserTest do
  use    ExUnit.Case
  import ExVCR.Mock

  alias  ExGithub.User

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes/user")
    :ok
  end


  test "can fetch a single user" do
    use_cassette "user_ortuna" do
      user = User.fetch(user: "ortuna")
      assert user["login"] == "Ortuna"
      assert user["id"]    == 221008
    end
  end
  
  test "can get the current user" do
    use_cassette "user_self" do
      user = User.current(auth_token: "auth_token")
      assert user["login"] == "Ortuna"
      assert user["id"]    == 221008
    end
  end

  test "can update the current user" do
    use_cassette "update" do
      user = User.update([company: "some_company"], auth_token: "auth_token")
      assert user["login"] == "Ortuna"
      assert user["id"]    == 221008
      assert user["company"] == "some_company"
    end
  end

  test "can get a users emails" do
    use_cassette "emails" do
      emails = User.emails(auth_token: "auth_token")
      first  = Enum.at(emails, 0)

      assert Enum.count(emails) == 2
      assert first == "some@email.com"
    end
  end

  test "can get a users followers" do
    use_cassette "followers" do
      followers = User.followers(user: "ortuna")

      assert Enum.count(followers) == 11
    end
  end

  test "if a user is following a target user" do
    use_cassette "following" do
      assert User.following?(user: "ortuna", target_user: "vim-scripts")
      refute User.following?(user: "ortuna", target_user: "some_other_user")
    end
  end

  test "can follow/unfollow a user" do
    use_cassette "follow" do
      assert User.follow(user: "vim-scripts", auth_token: "auth_token")   == 204
      assert User.unfollow(user: "vim-scripts", auth_token: "auth_token") == 204
    end
  end

end
