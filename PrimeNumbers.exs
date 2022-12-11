defmodule PrimeNumbers do

  defp checkLimit(n), do: trunc(:math.sqrt(n))

  defp isDivisor(n,k) do
    if rem(n,k)==0 do
      k
    else
      nil
    end
  end

  defp hasDivisor(n,k) do
    if n<4 do
      nil
    else
      if k<=checkLimit(n) do
        if isPrimeNumber(k) && (isDivisor(n,k) != nil) do
          isDivisor(n,k)
        else
          hasDivisor(n,k+1)
        end
      else
        nil
      end
    end
  end

  def getDivisor(n) do
    hasDivisor(n,2)
  end

  def isPrimeNumber(n) do
    if getDivisor(n)==nil do
      true
    else
      false
    end
  end

  def checkNumbers(min,max) do
    if isPrimeNumber(min) do
      IO.puts "! #{min} is prime number!"
    else
      IO.puts "  #{min} / #{getDivisor(min)} = #{div(min,getDivisor(min))}"
    end
    if min<max, do: checkNumbers(min+1,max)
  end

  def findPrimeNumbers(min,max,n\\1) do
    if isPrimeNumber(min) do
      IO.puts "#{n} -> #{min}"
      if min<max, do: findPrimeNumbers(min+1,max,n+1)
    else
      if min<max, do: findPrimeNumbers(min+1,max,n)
    end
  end

  defp aFindPrimeNumbers(n,min,max,caller,i\\1) do
	  if min>max do
	    send(caller, {:prime_number, 0})
	  else
	    if isPrimeNumber(min) do
	      result = "[#{n}.#{i}] -> #{min}"
	      send(caller, {:prime_number, result})
        aFindPrimeNumbers(n,min+1,max,caller,i+1)
	    else
        aFindPrimeNumbers(n,min+1,max,caller,i)
	    end
	  end
  end

  defp aGetResult() do
	  receive do
	    {:prime_number, result} -> result
	  after
	    24*60*60*1000 -> -1
	  end
  end

 defp aGetResults(n,k\\1) do
  if n>0 do
    result = aGetResult()
    if result>0 do
   	  IO.puts "#{k} #{result}"
	    aGetResults(n,k+1)
    else
	    if result==0 do
		    aGetResults(n-1,k)
	    else
	      _message = "stopped on timeout"
	    end
    end
  else
    _message = "done"
  end
 end

  def aGetPrimeNumbers(n,scope,prefix\\1) do
    if n>0 do
	    startTime = :os.system_time(:millisecond)
	    caller = self()
	    async_query = fn a,b,c -> spawn(fn -> aFindPrimeNumbers(a+1, a*b+prefix, (a+1)*b+prefix-1, c) end) end
	    Enum.each(0..n-1, &async_query.(&1, scope, caller))
	    message = aGetResults(n)
	    time = (:os.system_time(:millisecond) - startTime) / 1000
	    IO.puts "#{message} in #{time} seconds"
	  end
  end

  def info() do
    IO.puts "PrimeNumbers.getDivisor(n)"
    IO.puts "PrimeNumbers.isPrimeNumber(n)"
    IO.puts "PrimeNumbres.checkNumbers(min, max)"
    IO.puts "PrimeNumbers.findPrimeNumbers(min, max)"
	  IO.puts "PrimeNumbers.aGetPrimeNumbers(n, scope, prefix)"
  end

end
