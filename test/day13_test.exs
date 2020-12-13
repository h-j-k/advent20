defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.{Day13, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 4207

  @tag timeout: 600_000
  test "part2", do: assert part2(@input) == 725850285300475
end