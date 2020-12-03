defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03
  import AdventUtils

  test "part1" do
    assert part1(to_list("./inputs/day03.txt", [index: true])) == 200
  end

  test "part2" do
    assert part2(to_list("./inputs/day03.txt", [index: true])) == 3737923200
  end
end
