import Config

config :friends, Friends.Repo,
  database: "friends",
  # username: "postgres",
  username: "ectotester",
  # password: "postgres",
  password: "ectotester",
  hostname: "localhost"

config :friends, ecto_repos: [Friends.Repo]
