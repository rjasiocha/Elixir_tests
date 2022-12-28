defmodule PrimeNumbers.Repo do
  use Ecto.Repo,
    otp_app: :prime_numbers,
    adapter: Ecto.Adapters.MyXQL
end
