defmodule AdventOfCode.Day23 do
  @moduledoc "Day 23"

  defp parse(input), do: Enum.map(String.graphemes(input), &String.to_integer/1)

  defp round(0, cups, _) do
    {tail, [_ | head]} = Enum.split_while(cups, &(&1 != 1))
    Enum.join(Enum.map(head ++ tail, &Integer.to_string/1))
  end

  defp round(i, [current, a, b, c | rest], {min, max}) do
    {tail, head} = Enum.split_while(max..min, &(&1 != current - 1))
    destination = Enum.find(head ++ tail, &(!(&1 in [a, b, c])))
    {start, others} = Enum.split_while(rest, &(&1 != destination))
    round(i - 1, start ++ [destination, a, b, c] ++ Enum.drop(others, 1) ++ [current], {min, max})
  end

  def part1(input), do: round(100, parse(hd(input)), {1, 9})

  def part2(input), do: 0
end