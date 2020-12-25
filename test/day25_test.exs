defmodule AdventOfCode.Day25Test do
  use ExUnit.Case, async: true

  import AdventOfCode.{Day25, TestUtils}

  @input test_file([to_integer: true])

  test "part1", do: assert part1(@input) == 11288669
end