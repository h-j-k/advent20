defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.{Day10, TestUtils}

  @input test_file([to_integer: true])

  test "part1", do: assert part1(@input) == 1980

  test "part2", do: assert part2(@input) == 4628074479616
end