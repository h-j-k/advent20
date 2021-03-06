defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.{Day01, TestUtils}

  @input test_file([to_integer: true])

  test "part1", do: assert part1(@input) == 357504

  test "part2", do: assert part2(@input) == 12747392
end