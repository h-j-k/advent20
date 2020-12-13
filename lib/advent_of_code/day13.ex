defmodule AdventOfCode.Day13 do
  @moduledoc "Day 13"

  def part1([timestamp, buses]) do
    target = String.to_integer(timestamp)
    String.split(buses, ",")
    |> Enum.map(&(if &1 == "x", do: target, else: String.to_integer(&1)))
    |> Enum.max_by(&(rem(target, &1)))
    |> (&(&1 * (&1 - rem(target, &1)))).()
  end

  defp process({bus, index}, {t, step}) do
    if rem(t + index, bus) == 0,
       do: {t, (&(div(&1 * &2, Integer.gcd(&1, &2)))).(bus, step)},
       else: process({bus, index}, {t + step, step})
  end

  def part2([_, buses]) do
    String.split(buses, ",")
    |> Enum.with_index
    |> Enum.filter(fn {v, _} -> v != "x" end)
    |> Enum.map(fn {v, index} -> {String.to_integer(v), index} end)
    |> Enum.reduce({0, 1}, &process/2)
    |> elem(0)
  end
end