defmodule AdventOfCode.Day04 do
  @moduledoc "Day 04"

  defp check(list, regex), do: Enum.count(list, &(Enum.count(Regex.scan(regex, &1)) == 7))

  def part1(list), do: check(list, ~r/\b(byr|iyr|eyr|hgt|hcl|ecl|pid):/)

  def part2(list), do: check(
    list,
    ~r/\b(byr:(19[2-9][0-9]|200[0-2])|iyr:20(1[0-9]|20)|eyr:20(2[0-9]|30)|hgt:(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)|hcl:#[0-9a-f]{6}|ecl:(amb|blu|brn|gry|grn|hzl|oth)|pid:[0-9]{9})\b/
  )
end