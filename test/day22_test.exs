defmodule AdventOfCode.Day22Test do
  use ExUnit.Case, async: true

  import AdventOfCode.{Day22, TestUtils}

  @input test_file([grouped: true])

  test "part1", do: assert part1(@input) == 32199

  test "part2", do: assert part2(@input) == 33780
end