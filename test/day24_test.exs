defmodule AdventOfCode.Day24Test do
  use ExUnit.Case, async: true

  import AdventOfCode.{Day24, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 465

  @tag timeout: :infinity
  test "part2", do: assert part2(@input) == 4078
end