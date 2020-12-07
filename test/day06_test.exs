defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.{Day06, TestUtils}

  @input test_file([grouped: true])

  test "part1", do: assert part1(@input) == 6947

  test "part2", do: assert part2(@input) == 3398
end