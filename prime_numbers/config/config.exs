import Config

config :prime_numbers, PrimeNumbers.Repo,
  database: "prime_numbers",
  username: "ectotester",
  password: "ectotester",
  hostname: "localhost",
  log: false
  
config :prime_numbers, ecto_repos: [PrimeNumbers.Repo]
