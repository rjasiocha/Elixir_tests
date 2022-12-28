defmodule PrimeNumbers.Prime do
  use Ecto.Schema

  schema "primes" do
    field :prime_number, :integer
  end
end
