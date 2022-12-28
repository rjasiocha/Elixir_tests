defmodule PrimeNumbers.Repo.Migrations.CreatePrimes do
  use Ecto.Migration

  def change do
    create table(:primes) do
      add :prime_number, :integer
    end
  end
end
