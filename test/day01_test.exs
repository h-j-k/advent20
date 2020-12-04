defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01
  import AdventUtils

  @input to_list("./inputs/day01.txt", [number: true])

  test "part1" do
    assert part1(@input) == 357504
  end

  test "part2" do
    assert part2(@input) == 12747392
  end
end
