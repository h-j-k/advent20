defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  @input AdventUtils.to_list("./inputs/day04.txt", [flattened: true])

  test "part1", do: assert part1(@input) == 256

  test "part2", do: assert part2(@input) == 198
end