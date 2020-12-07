defmodule AdventOfCode.Day02 do
  @moduledoc "Day 02"

  defp process(list, is_valid), do: Enum.count(
    Enum.map(list, &(Regex.run(~r/^(\d+)\-(\d+) (.): (.+)$/, &1))),
    fn [_, a, b, char, value] -> is_valid.(String.to_integer(a), String.to_integer(b), char, value) end
  )

  defp is_char_at(value, index, char), do: String.at(value, index - 1) == char

  def part1(list), do: process(list, &(AdventOfCode.count_chars(&4)[&3] in &1..&2))

  def part2(list), do: process(list, &(is_char_at(&4, &1, &3) != is_char_at(&4, &2, &3)))
end