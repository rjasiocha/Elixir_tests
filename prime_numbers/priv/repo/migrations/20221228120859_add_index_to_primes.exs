defmodule PrimeNumbers.Repo.Migrations.AddIndexToPrimes do
  use Ecto.Migration

  def change do
    create index("primes", :prime_number, unique: true)
  end
end
