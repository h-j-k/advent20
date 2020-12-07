defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.{Day07, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 235

  test "part2", do: assert part2(@input) == 158493
end