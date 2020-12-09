defmodule AdventOfCode.Day09 do
  @moduledoc "Day 09"

  defp number({number, _}), do: number

  def process(list, n) do
    number(
      Enum.find(
        Enum.drop(list, n),
        fn {v, index} ->
          AdventOfCode.Day01.pairs_to(Enum.map(Enum.slice(list, index - n, n), &number/1), v) == nil
        end
      )
    )
  end

  def part1(list), do: process(list, 25)

  def part2(_list), do: -1
end