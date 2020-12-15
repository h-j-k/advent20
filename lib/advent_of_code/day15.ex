defmodule AdventOfCode.Day15 do
  @moduledoc "Day 15"

  defp process(input, limit) do
    base = Map.new(Enum.with_index(String.split(hd(input), ",")), fn {n, t} -> {String.to_integer(n), [t]} end)
    Enum.count(base)..(limit - 1)
    |> Enum.reduce(
         {base, nil},
         fn turn, {seen, last} ->
           next = case seen[last] do
             [a, b] -> a - b
             _ -> 0
           end
           {Map.update(seen, next, [turn], fn [h | _] -> [turn, h] end), next}
         end
       )
    |> elem(1)
  end

  def part1(input), do: process(input, 2020)

  def part2(input), do: process(input, 30000000)
end