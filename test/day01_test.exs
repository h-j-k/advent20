defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01
  import AdventUtils

  test "part1" do
    assert part1(to_list("./inputs/day01.txt", [number: true])) == 357504
  end

  test "part2" do
    assert part2(to_list("./inputs/day01.txt", [number: true])) == 12747392
  end
end
