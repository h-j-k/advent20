defmodule AdventOfCode.Day10 do
  @moduledoc "Day 10"

  def part1(list) do
    {diffs, _} = Enum.reduce(
      Enum.sort(list),
      {%{3 => 1}, 0},
      fn x, {seen, last} -> {Map.update(seen, x - last, 1, &(&1 + 1)), x} end
    )
    diffs[1] * diffs[3]
  end

  def part2(list), do: -1
end