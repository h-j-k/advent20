defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  @input AdventUtils.to_list("./inputs/day02.txt")

  test "part1", do: assert part1(@input) == 556

  test "part2", do: assert part2(@input) == 605
end