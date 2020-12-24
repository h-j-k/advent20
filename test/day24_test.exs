defmodule AdventOfCode.Day24Test do
  use ExUnit.Case

  import AdventOfCode.{Day24, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 465

  test "part2", do: assert part2(@input) == 0
end