defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.{Day15, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 273

  test "part2", do: assert part2(@input) == 0

  @example %{
    "0,3,6" => 436,
    "1,3,2" => 1,
    "2,1,3" => 10,
    "1,2,3" => 27,
    "2,3,1" => 78,
    "3,2,1" => 438,
    "3,1,2" => 1836
  }

  test "example", do: Enum.each(@example, fn {given, expected} -> assert part1([given]) == expected end)
end