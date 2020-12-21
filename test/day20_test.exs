defmodule AdventOfCode.Day20Test do
  use ExUnit.Case

  import AdventOfCode.{Day20, TestUtils}

  @input test_file([grouped: true])

  test "part1", do: assert part1(@input) == 11788777383197

  test "part2", do: assert part2(@input) == 2242
end