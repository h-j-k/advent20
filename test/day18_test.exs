defmodule AdventOfCode.Day18Test do
  use ExUnit.Case, async: true

  import AdventOfCode.{Day18, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 3885386961962

  test "part2", do: assert part2(@input) == 112899558798666
end