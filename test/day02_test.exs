defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02
  import AdventUtils

  @inputs to_list("./inputs/day02.txt")

  test "part1" do
    assert part1(@inputs) == 556
  end

  test "part2" do
    assert part2(@inputs) == 605
  end
end
