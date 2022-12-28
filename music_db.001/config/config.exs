import Config

config :music_db, MusicDB.Repo,
  database: "music_db",
  username: "ectotester",
  password: "ectotester",
  hostname: "localhost"

config :music_db, ecto_repos: [MusicDB.Repo]
