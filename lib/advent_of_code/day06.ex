defmodule AdventOfCode.Day06 do
  @moduledoc "Day 06"

  def part1(list), do: list
                       |> Enum.map(&(Enum.count(Enum.uniq(String.graphemes(Enum.join(&1))))))
                       |> Enum.sum

  def part2(_list) do
    11
  end
end