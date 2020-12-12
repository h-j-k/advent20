defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  # import AdventOfCode.{Day11, TestUtils}
  import AdventOfCode.Day11

  # Running with example as part two takes 8 minutes to run on GitHub Actions
  # @input test_file([indexed: true])
  @input Enum.with_index(
           [
             "L.LL.LL.LL",
             "LLLLLLL.LL",
             "L.L.L..L..",
             "LLLL.LL.LL",
             "L.LL.LL.LL",
             "L.LLLLL.LL",
             "..L.L.....",
             "LLLLLLLLLL",
             "L.LLLLLL.L",
             "L.LLLLL.LL"
           ]
         )

  test "part1", do: assert part1(@input) == 37 # 2329

  @tag timeout: :infinity
  test "part2", do: assert part2(@input) == 26 # 2138
end