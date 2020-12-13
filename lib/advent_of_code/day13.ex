defmodule AdventOfCode.Day13 do
  @moduledoc "Day 13"

  def part1(list) do
    target = String.to_integer(Enum.at(list, 0))
    String.split(Enum.at(list, 1), ",")
    |> Enum.map(&(if &1 == "x", do: target, else: String.to_integer(&1)))
    |> Enum.max_by(&(rem(target, &1)))
    |> (&(&1 * (&1 - rem(target, &1)))).()
  end

  defp process({bus, index}, {t, step}) do
    if Integer.mod(t + index, bus) == 0,
       do: {t, lcm(step, bus)},
       else: process({bus, index}, {t + step, step})
  end

  defp lcm(a, b), do: div(a * b, Integer.gcd(a, b))

  def part2(list) do
    Enum.with_index(String.split(Enum.at(list, 1), ","))
    |> Enum.filter(fn {v, _} -> v != "x" end)
    |> Enum.map(fn {v, index} -> {String.to_integer(v), index} end)
    |> Enum.reduce({0, 1}, &process/2)
    |> elem(0)
  end
end