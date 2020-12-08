defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.{Day08, TestUtils}

  @input test_file([indexed: true])

  test "part1", do: assert part1(@input) == 2058

  test "part2", do: assert part2(@input) == 1000
end