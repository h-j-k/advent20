defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.{Day12, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 2057

  test "part2", do: assert part2(@input) == 0
end