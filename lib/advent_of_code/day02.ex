defmodule AdventOfCode.Day02 do
  @moduledoc "Day 02"

  def part1(list) do
    list
    |> Enum.count(
         fn line ->
           [_, min, max, char, password] = Regex.run(~r/^(\d+)\-(\d+) (.): (.+)$/, line)
           {:ok, regex} = Regex.compile("#{char}")
           (
             Regex.scan(regex, password)
             |> length) in String.to_integer(min)..String.to_integer(max)
         end
       )
  end

  def part2(list) do
    list
    |> Enum.count(
         fn line ->
           [_, p1, p2, char, password] = Regex.run(~r/^(\d+)\-(\d+) (.): (.+)$/, line)
           is_valid = &(String.at(password, String.to_integer(&1) - 1) == char)
           is_valid.(p1) != is_valid.(p2)
         end
       )
  end
end