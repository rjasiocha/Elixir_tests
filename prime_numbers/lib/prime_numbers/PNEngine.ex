defmodule PNEngine do

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
    if DataService.isInPrimes(n) == :true do
      true
    else
      if getDivisor(n)==nil do
        DataService.insert(n)
        true
      else
        false
      end
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

  defp aFindPrimeNumber(n, min,max,caller) do
    if min>max do
      send(caller, {:prime_number, n, 0})
    else
      if isPrimeNumber(min) do
        send(caller, {:prime_number, n, min})
        workerHelper(n, min+1,max,caller)
      else
        workerHelper(n, min+1,max,caller)
      end
    end
  end

  defp getMaxIndex(index) do
    Enum.reduce(index,0,fn _i={n,_}, acc -> max(acc, n) end)
  end

  defp getElement(index, i) do
    if index==[] do
      []
    else
      [{n,id} | tail]=index
      if n==i do
        [{n,id}]
      else
        getElement(tail, i)
      end
    end
  end

  defp workerListener() do
    receive do
      {:stop} -> {:stop}
    after
      1 -> {:continue}
    end
  end

  defp workerHelper(n, min,max,supervisor_id) do
    case workerListener() do
      {:stop} -> aFindPrimeNumber(n, max+1, max, supervisor_id)
      {_} -> aFindPrimeNumber(n, min,max, supervisor_id)
    end
  end

  defp worker(n,supervisor_id) do
    worker_id=self()
    send(supervisor_id, {:worker, n, worker_id})
    if n<4 do
      Process.sleep((n+1)*100)
    end
    aFindPrimeNumber(n, 10**n, 10**(n+1)-1, supervisor_id)
  end

  defp resultListener() do
    receive do
      {:worker, n, id} -> {:worker, n, id}
      {:prime_number, n, result} -> {:result, n, result}
    end
  end

  defp resultHelper(i, result, index) do
    if result > 0 do
      IO.puts "[#{i}] => #{result}"
      element=getElement(index, i-1)
      if element != [] do
        [{_,worker_id}]=element
        send(worker_id, {:stop})
      end
      aFindMaxPrimeNumber(index)
    else
      if length(index)>1 do
        element=getElement(index, i)
        index=index -- element
        IO.puts "[#{i}] => Zako??czony"
        aFindMaxPrimeNumber(index)
      else
        aFindMaxPrimeNumber(index)
      end
    end
  end

  defp workerRegisterHelper(i, id, index) do
    index=[{i, id} | index]
    IO.puts "[#{i}] => Zarejestrowany"
    if length(index)>0 do
      aFindMaxPrimeNumber(index)
    end
  end

  def aFindMaxPrimeNumber(index\\[]) do
    caller=self()
    async_query=fn a,b -> spawn(fn -> worker(a,b) end) end
    active_workers=length(index)
    if active_workers<2 do
      if active_workers==0 do
        async_query.(0, caller)
      else
        async_query.(getMaxIndex(index)+1, caller)
      end
    end
    #IO.puts "liczba aktywnych proces??w #{length(index)}"
    case resultListener() do
      {:result, i, result} -> resultHelper(i, result, index)
      {:worker, i, id} -> workerRegisterHelper(i, id, index)
    end
  end

  def info() do
    IO.puts "PNEngine.getDivisor(n)"
    IO.puts "PNEngine.isPrimeNumber(n)"
    IO.puts "PNEngine.checkNumbers(min, max)"
    IO.puts "PNEngine.findPrimeNumbers(min, max)"
    IO.puts "PNEngine.aGetPrimeNumbers(n, scope, prefix)"
    IO.puts "PNEngine.aFindMaxPrimeNumber()"
  end

end
