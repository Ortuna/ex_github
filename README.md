# ExGithub
[![Build Status](https://travis-ci.org/Ortuna/ex_github.png?branch=master)](https://travis-ci.org/Ortuna/ex_github)

*A Github API client for Elixir!*

##Usage
  * TODO:
  * Install Instruction
  * Documentation
  * Dependencies

##API

###ExGithub.User

####Overview
  The `ExGithub.User` module allows for interaction with 
user related functionality on github.  Some functionality
will require an authenticated user via `auth_token`. 

  Most data is processed by `JSON.decode` via 
[elixir-json](https://github.com/cblage/elixir-json). The
data is returned as a [HashDict](http://elixir-lang.org/docs/stable/HashDict.html).

####fetch(user\_name)

```elixir
  iex> ExGithub.User.fetch("ortuna")
    #HashDict<[{"public_repos", 58}, {"company", "test"},
    {"created_at", "2010-03-12T00:56:06Z"}, {"hireable", true},
    {"location", "Arlington, va"}, {"name", "Sumeet Singh"}, {"bio", nil},
    {"gists_url", "https://api.github.com/users/Ortuna/gists{/gist_id}"},
    {"organizations_url", "https://api.github.com/users/Ortuna/orgs"},
    {"followers_url", "https://api.github.com/users/Ortuna/followers"},  
    ...
```

####user(auth\_token)

Given a valid `auth_token`,  the `user` function returns
the current authenticated user. 

```elixir
  iex> ExGithub.User.user("11112222233334444455555abc")
    #HashDict<[{"public_repos", 58}, {"company", "test"},
    {"created_at", "2010-03-12T00:56:06Z"}, {"hireable", true},
    {"location", "Arlington, va"}, {"name", "Sumeet Singh"}, {"bio", nil},
    {"gists_url", "https://api.github.com/users/Ortuna/gists{/gist_id}"},
    {"organizations_url", "https://api.github.com/users/Ortuna/orgs"},
    {"followers_url", "https://api.github.com/users/Ortuna/followers"},  
    ...
```

####update(auth\_token, values)

Updates the current authenticated user with `values`, where  `values` is a 
KeywordList.  The updated user is also returned.

```elixir
  iex> ExGithub.User.update("auth_token", company: "test", location: "The Beach")
    #HashDict<[{"public_repos", 58}, {"company", "test"},
    {"created_at", "2010-03-12T00:56:06Z"}, {"hireable", true},
    {"location", "Arlington, va"}, {"name", "Sumeet Singh"}, {"bio", nil},
    {"gists_url", "https://api.github.com/users/Ortuna/gists{/gist_id}"},
    {"organizations_url", "https://api.github.com/users/Ortuna/orgs"},
    {"followers_url", "https://api.github.com/users/Ortuna/followers"},  
    ...
```

####emails(auth\_token)

returns a list of emails registered for the current user.
```elixir
  iex> ExGithub.User.emails("auth_token")
    ["some_email@gmail.com", "ortuna@gmail.com"]
```

####followers(user\_name)

returns a list of followers for the given `user_name`
```elixir
  ExGithub.User.followers("ortuna")
```

####following?(user\_name, target\_name)
returns wheather this user is following the `target_name`

```elixir
  iex> ExGithub.User.following?("ortuna", "elixir")
    true
```

####follow(auth\_token, target\_name)
Given a valid `auth_token`, follows the `target_name` user.

```elixir
  iex> ExGithub.User.follow("auth_token", "elixir")
    true
```

####unfollow(auth\_token, target\_name)
Given a valid `auth_token`, unfollows the `target_name` user.

```elixir
  iex> ExGithub.User.unfollow("auth_token", "php")
    true 
```


