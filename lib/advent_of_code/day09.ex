defmodule AdventOfCode.Day09 do
  @moduledoc "Day 09"

  defp process(list, n \\ 25), do: Enum.find(
    Enum.drop(Enum.with_index(list), n),
    fn {x, index} -> AdventOfCode.Day01.pairs_to(Enum.slice(list, index - n, n), x) == nil end
  )

  def part1(list), do: elem(process(list), 0)

  def part2(list) do
    {target, start} = process(list)
    Enum.find_value(
      start..0,
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