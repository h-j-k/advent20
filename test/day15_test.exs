defmodule AdventOfCode.Day15Test do
  use ExUnit.Case, async: true

  import AdventOfCode.{Day15, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 273

  test "part2", do: assert part2(@input) == 47205
end