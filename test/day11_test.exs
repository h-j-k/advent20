defmodule AdventOfCode.Day11Test do
  use ExUnit.Case, async: true

  import AdventOfCode.{Day11, TestUtils}

  @input test_file([indexed: true])

  test "part1", do: assert part1(@input) == 2329

  test "part2", do: assert part2(@input) == 2138
end