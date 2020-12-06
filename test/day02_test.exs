defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02
  import AdventUtils

  @input test_file()

  test "part1", do: assert part1(@input) == 556

  test "part2", do: assert part2(@input) == 605
end