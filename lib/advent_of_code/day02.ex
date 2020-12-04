defmodule AdventOfCode.Day02 do
  @moduledoc "Day 02"

  import String

  defp is_valid(list, check) do
    to_tuple = &(List.to_tuple(Regex.run(~r/^(\d+)\-(\d+) (.): (.+)$/, &1)))
    to_props = fn {_, p1, p2, char, password} -> {to_integer(p1), to_integer(p2), char, password} end
    Enum.count(list, &(check.(to_props.(to_tuple.(&1)))))
  end

  def part1(list) do
    check = fn {min, max, char, password} -> Enum.frequencies(graphemes(password))[char] in min..max end
    is_valid(list, check)
  end

  def part2(list) do
    check = fn {p1, p2, char, password} ->
      is_char_at = &(at(password, &1 - 1) == char)
      is_char_at.(p1) != is_char_at.(p2)
    end
    is_valid(list, check)
  end
end