defmodule AdventOfCode.Day09 do
  @moduledoc "Day 09"

  defp number({number, _}), do: number

  def process(list), do: Enum.find(
    Enum.drop(list, 25),
    fn {v, index} -> AdventOfCode.Day01.pairs_to(Enum.map(Enum.slice(list, index - 25, 25), &number/1), v) == nil end
  )

  def part1(list), do: number(process(list))

  def part2(_list), do: -1
end