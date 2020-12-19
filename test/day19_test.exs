defmodule AdventOfCode.Day19Test do
  use ExUnit.Case, async: true

  import AdventOfCode.{Day19, TestUtils}

  @input test_file([grouped: true])

  test "part1", do: assert part1(@input) == 139

  test "part2", do: assert part2(@input) == 0
end