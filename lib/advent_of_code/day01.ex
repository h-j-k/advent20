defmodule AdventOfCode.Day01 do
  @moduledoc "Day 01"

  @year 2020

  defp pairs_to(numbers, target), do: Enum.find(numbers, &((target - &1) in numbers))

  def part1(numbers), do: (&(&1 * (@year - &1))).(pairs_to(numbers, @year))

  def part2(numbers), do: Enum.find_value(
    numbers,
    fn x ->
      case pairs_to(numbers, @year - x) do
        nil -> nil
        y -> x * y * (@year - x - y)
      end
    end
  )
end