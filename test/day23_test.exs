defmodule AdventOfCode.Day23Test do
  use ExUnit.Case

  import AdventOfCode.{Day23, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == "82934675"

  test "part2", do: assert part2(@input) == 0
end