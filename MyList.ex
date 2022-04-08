defmodule MyList do
  def sum([]), do: 0
  def sum([ head | tail]), do: head + sum(tail)
  def info(), do: IO.puts "Use MyList.sum [n1, n2, n3, ...]"
end

IO.puts MyList.info()
