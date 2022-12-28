defmodule DataService do

  def isInPrimes(value) do
    prime = PrimeNumbers.Repo.get_by(PrimeNumbers.Prime, prime_number: value)
    if prime == nil do
      :false
    else
      :true
    end
  end

  def insert(value) do
    if isInPrimes(value) == :false and value < 2147483648 do
      prime = %PrimeNumbers.Prime{}
      changeset = PrimeNumbers.Prime.changeset(prime, %{prime_number: value})
      PrimeNumbers.Repo.insert(changeset)
    end
  end

  def info() do
    IO.puts "DataService.isInPrimes(value)"
    IO.puts "DataService.insert(value)"
  end

end


