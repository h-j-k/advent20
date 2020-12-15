defmodule AdventOfCode.Day15 do
  @moduledoc "Day 15"

  defp process(input, limit) do
    base = Map.new(Enum.with_index(String.split(hd(input), ","), 1), fn {n, t} -> {String.to_integer(n), [t]} end)
    (1 + Enum.count(base))..limit
    |> Enum.reduce(
         {base, nil},
         fn turn, {seen, last} ->
           past = Enum.take(Map.get(seen, last, []), 2)
           next = if Enum.count(past) < 2, do: 0, else: Enum.reduce(past, &(&2 - &1))
           {Map.update(seen, next, [turn], fn [h | rest] -> [turn, h] end), next}
         end
       )
    |> elem(1)
  end

  def part1(input), do: process(input, 2020)

  def part2(input), do: process(input, 30000000)
end