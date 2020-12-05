defmodule AdventOfCode.Day05 do
  @moduledoc "Day 05"

  @mapping %{"F" => "0", "B" => "1", "L" => "0", "R" => "1"}

  defp tr(value), do: Enum.join(Enum.map(String.graphemes(value), &(@mapping[&1])))

  defp process(list), do: Enum.map(list, &(String.to_integer(tr(&1), 2)))

  def part1(list), do: Enum.max(process(list))

  def part2(list) do
    [sum, {min, max}] = (&([Enum.sum(&1), Enum.min_max(&1)])).(process(list))
    div((1 + max - min) * (min + max), 2) - sum
  end
end