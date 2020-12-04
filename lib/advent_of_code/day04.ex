defmodule AdventOfCode.Day04 do
  @moduledoc "Day 04"

  def part1(list) do
    regex = ~r/\b(byr|iyr|eyr|hgt|hcl|ecl|pid):/
    list
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.map(fn v -> Enum.join(v, " ") end)
    |> Enum.count(fn r -> (Regex.scan(regex, r) |> length) == 7 end)
  end
end