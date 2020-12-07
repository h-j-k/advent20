defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.{Day03, TestUtils}

  @input test_file([indexed: true])

  test "part1", do: assert part1(@input) == 200

  test "part2", do: assert part2(@input) == 3737923200
end