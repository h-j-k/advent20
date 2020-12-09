defmodule AdventOfCode.Day09 do
  @moduledoc "Day 09"

  defp process(list, n \\ 25), do: Enum.find_value(
    Enum.drop(Enum.with_index(list), n),
    fn {x, index} -> if AdventOfCode.Day01.pairs_to(Enum.slice(list, index - n, n), x) == nil, do: x, else: nil end
  )

  def part1(list), do: process(list)

  def part2(list) do
    target = process(list)
    Enum.find_value(
      0..(Enum.count(list) - 1),
      fn index ->
        result = Enum.reduce_while(
          Enum.reverse(Enum.take(list, index)),
          [],
          fn x, acc -> (&({(if Enum.sum(&1) >= target, do: :halt, else: :cont), &1})).([x | acc]) end
        )
        if Enum.sum(result) == target, do: Enum.sum(Tuple.to_list(Enum.min_max(result))), else: nil
      end
    )
  end
end