defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.{Day09, TestUtils}

  @input test_file([to_integer: true, indexed: true])

  test "part1", do: assert part1(@input) == 15690279

  test "part2", do: assert part2(@input) == -1
end