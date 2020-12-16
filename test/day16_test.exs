defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.{Day16, TestUtils}

  @input test_file([grouped: true])

  test "part1", do: assert part1(@input) == 26026

  test "part2", do: assert part2(@input) == 0
end