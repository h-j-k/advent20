defmodule AdventOfCode.Day01 do
  @moduledoc "Day 01"

  defp pairs_to(numbers, target) do
    Enum.find(numbers, &((target - &1) in numbers))
  end

  def part1(numbers) do
    (&(&1 * (2020 - &1))).(pairs_to(numbers, 2020))
  end

  def part2(numbers) do
    Enum.find_value(
      numbers,
      fn x ->
        case pairs_to(numbers, 2020 - x) do
          nil -> nil
          r -> x * r * (2020 - x - r)
        end
      end
    )
  end
end
