defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.{Day17, TestUtils}

  @input test_file([indexed: true])

  test "part1", do: assert part1(@input) == 301

  test "part2", do: assert part2(@input) == 0
end