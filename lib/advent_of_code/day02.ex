defmodule AdventOfCode.Day02 do
  @moduledoc "Day 02"

  defp is_valid(list, check) do
    list
    |> Enum.count(
         fn line ->
           {_, p1, p2, char, password} = List.to_tuple(Regex.run(~r/^(\d+)\-(\d+) (.): (.+)$/, line))
           check.({String.to_integer(p1), String.to_integer(p2), char, password})
         end
       )
  end

  def part1(list) do
    check = fn {min, max, char, password} ->
      (password
       |> String.graphemes
       |> Enum.frequencies)[char] in min..max
    end
    is_valid(list, check)
  end

  def part2(list) do
    check = fn {p1, p2, char, password} ->
      is_char_at = &(String.at(password, &1 - 1) == char)
      is_char_at.(p1) != is_char_at.(p2)
    end
    is_valid(list, check)
  end
end