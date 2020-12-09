defmodule AdventOfCode.Day09 do
  @moduledoc "Day 09"

  defp number({number, _}), do: number

  defp process(list), do: Enum.find(
    Enum.drop(list, 25),
    fn {v, index} -> AdventOfCode.Day01.pairs_to(Enum.map(Enum.slice(list, index - 25, 25), &number/1), v) == nil end
  )

  defp sums_to?(list, index, target) do
    result = Enum.reduce_while(
      Enum.reverse(Enum.take(list, index)),
      [],
      fn x, acc ->
        next = [number(x) | acc]
        {(if Enum.sum(next) >= target, do: :halt, else: :cont), next}
      end
    )
    if Enum.sum(result) == target,
       do: (fn {min, max} -> min + max end).(Enum.min_max(result)), else: nil
  end

  def part1(list), do: number(process(list))

  def part2(list) do
    {result, index} = process(list)
    Enum.find_value(
      Enum.filter(Enum.take(list, index), fn {v, _} -> v <= 1 + div(result, 2) end),
      fn {_, i} -> sums_to?(list, i, result) end
    )
  end
end