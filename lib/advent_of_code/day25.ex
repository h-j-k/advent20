defmodule AdventOfCode.Day25 do
  @moduledoc "Day 25"

  defp loop(i, n, target) when n == target, do: i
  defp loop(i, n, target), do: loop(i + 1, rem(7 * n, 20201227), target)

  defp solve(0, n, _), do: n
  defp solve(i, n, subject), do: solve(i - 1, rem(subject * n, 20201227), subject)

  def part1(input) do
    [card_public, door_public] = Enum.map(0..1, &(Enum.at(input, &1)))
    solve(loop(1, 7, card_public), 1, door_public)
  end
end