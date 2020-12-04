defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04
  import AdventUtils

  @input to_list("./inputs/day04.txt")

  test "part1" do
    assert part1(@input) == 256
  end

  test "part2" do
    assert part2(@input) == 198
  end
end
