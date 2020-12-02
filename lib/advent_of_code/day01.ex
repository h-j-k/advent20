defmodule AdventOfCode.Day01 do
  @moduledoc "Day 01"

  defp pairs_to(numbers, target) do
    Enum.find(numbers, fn x -> (target - x) in numbers end)
  end

  def part1(numbers) do
    pairs_to(numbers, 2020)
    |> (fn x -> x * (2020 - x) end).()
  end

  def part2(numbers) do
    numbers
    |> Enum.map(
         fn x ->
           case pairs_to(numbers, 2020 - x) do
             nil -> nil
             r -> {x, r, 2020 - x - r}
           end
         end
       )
    |> Enum.find(fn v -> v != nil end)
    |> (fn {a, b, c} -> a * b * c end).()
  end
end
