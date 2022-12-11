defmodule Kolo do
  @pi 3.14159

  def pole(r), do: r*r*@pi
  def obwod(r), do: 2*r*@pi
  def info() do
    IO.puts "Kolo.pole (r)"
    IO.puts "Kolo.obwod (r)"
  end
end

Kolo.info()

