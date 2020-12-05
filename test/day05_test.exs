defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  @input AdventUtils.to_list("./inputs/day05.txt")

  test "part1", do: assert part1(@input) == 901

  test "part2", do: assert part2(@input) == 661
end