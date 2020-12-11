defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.{Day11, TestUtils}

  @input test_file([indexed: true])

  @tag timeout: :infinity
  test "part1", do: assert part1(@input) == 2329

  test "part2", do: assert part2(@input) == -1
end