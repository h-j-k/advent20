defmodule AdventOfCode.Day03 do
  @moduledoc "Day 03"

  defp process(list, {right, down}) do
    Enum.count(
      Enum.take_every(list, down),
      fn {line, index} ->
        String.at(line, rem(div(index, down) * right, String.length(line))) == "#"
      end
    )
  end

  def part1(list) do
    process(list, {3, 1})
  end

  def part2(list) do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn move -> process(list, move) end)
    |> Enum.reduce(&(&1 * &2))
  end
end