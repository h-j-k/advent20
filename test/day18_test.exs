defmodule AdventOfCode.Day18Test do
  use ExUnit.Case, async: true

  import AdventOfCode.{Day18, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 3885386961962


  @example [
    "1 + 2 * 3 + 4 * 5 + 6",
    "1 + (2 * 3) + (4 * (5 + 6))",
    "2 * 3 + (4 * 5)",
    "5 + (8 * 3 + 9 + 3 * 4 * 3)",
    "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
    "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"
  ]

  test "part2", do: assert part2(@example) == 694173

  test "part example", do: Enum.each(@example, fn v -> IO.puts("#{v}\n\t#{part2([v])}") end)
end