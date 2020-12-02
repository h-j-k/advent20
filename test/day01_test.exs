defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01
  import AdventUtils

  test "part1" do
    assert part1(to_number_list("./inputs/day01.txt")) == 357504
  end

  test "part2" do
    assert part2(to_number_list("./inputs/day01.txt")) == 12747392
  end
end
