defmodule AdventOfCode.Day02 do
  @moduledoc "Day 02"

  import String

  defp process(list, is_valid), do: Enum.count(
    Enum.map(list, &(Enum.drop(Regex.run(~r/^(\d+)\-(\d+) (.): (.+)$/, &1), 1))),
    fn [a, b, char, value] -> is_valid.(to_integer(a), to_integer(b), char, value) end
  )

  defp is_char_at(value, char), do: &(at(value, &1 - 1) == char)

  def part1(list), do: process(list, &(AdventOfCode.count_chars(&4)[&3] in &1..&2))

  def part2(list), do: process(list, &(is_char_at(&4, &3).(&1) != is_char_at(&4, &3).(&2)))
end