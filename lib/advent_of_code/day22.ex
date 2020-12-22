defmodule AdventOfCode.Day22 do
  @moduledoc "Day 22"

  defp score(cards), do:
    Enum.reduce(Enum.with_index(Enum.reverse(cards), 1), 0, fn {x, i}, acc -> x * i + acc end)

  defp round(p1, p2) when p1 == [] when p2 == [], do: score(p1 ++ p2)
  defp round(p1, p2) when hd(p1) > hd(p2), do: round(Enum.concat(tl(p1), [hd(p1), hd(p2)]), tl(p2))
  defp round(p1, p2) when hd(p1) < hd(p2), do: round(tl(p1), Enum.concat(tl(p2), [hd(p2), hd(p1)]))

  def part1(input), do: round(
    Enum.map(tl(Enum.at(input, 0)), &String.to_integer/1),
    Enum.map(tl(Enum.at(input, 1)), &String.to_integer/1)
  )

  def part2(input) do
    0
  end
end