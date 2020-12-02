defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02
  import AdventUtils

  test "part1" do
    assert part1(to_list("./inputs/day02.txt")) == 556
  end

  test "part2" do
    assert part2(to_list("./inputs/day02.txt")) == 605
  end
end
