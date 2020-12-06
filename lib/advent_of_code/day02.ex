defmodule AdventOfCode.Day02 do
  @moduledoc "Day 02"

  import String

  defp is_valid(list, check) do
    to_tuple = &(Enum.drop(Regex.run(~r/^(\d+)\-(\d+) (.): (.+)$/, &1), 1))
    to_props = fn [p1, p2, char, password] -> check.(to_integer(p1), to_integer(p2), char, password) end
    Enum.count(list, &(to_props.(to_tuple.(&1))))
  end

  def part1(list), do: is_valid(list, &(AdventOfCode.count_chars(&4)[&3] in &1..&2))

  def part2(list) do
    is_char_at = fn char, password -> &(at(password, &1 - 1) == char) end
    is_valid(list, &((is_char_at.(&3, &4)).(&1) != (is_char_at.(&3, &4)).(&2)))
  end
end