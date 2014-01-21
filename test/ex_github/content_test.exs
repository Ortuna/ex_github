defmodule ContentTest do
  use   ExUnit.Case, async: false
  use   ExVCR.Mock
  alias ExGithub.Repo.Content

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
    :ok
  end

  test "can get a remote manifest" do
    use_cassette "manifest" do
      json = Content.fetch_content(owner: "Ortuna", repo: "progit-bana", path: "manifest.json")
      assert json["decoded_content"] == "{\n    \"title\": \"Pro Git\",\n    \"cover_image\": \"assets/cover.jpg\",\n    \"pages\":\n    {\n        \"Preface\": \"01-introduction/01-chapter1.markdown\"\n    }\n}\n"
    end
  end

end


