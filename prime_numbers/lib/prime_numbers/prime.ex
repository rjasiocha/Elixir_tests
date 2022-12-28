defmodule PrimeNumbers.Prime do
  use Ecto.Schema

  schema "primes" do
    field :prime_number, :integer
  end

  def changeset(prime, params \\ %{}) do
    prime
    |> Ecto.Changeset.cast(params, [:prime_number])
    |> Ecto.Changeset.validate_required([:prime_number])
  end

end
