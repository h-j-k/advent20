defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  import AdventOfCode.{Day14, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 7997531787333

  test "part2", do: assert part2(@input) == 0
end