defmodule AdventOfCode.Day06 do
  @moduledoc "Day 06"

  defp process(list, counter), do: Enum.reduce(
    Enum.map(list, &({AdventOfCode.count_chars(Enum.join(&1)), Enum.count(&1)})),
    0,
    fn {answers, count}, subtotal -> counter.(answers, count) + subtotal end
  )

  def part1(list), do: process(list, fn answers, _ -> Enum.count(answers) end)

  def part2(list), do: process(list, &(Enum.count(&1, fn {_, v} -> v == &2 end)))
end