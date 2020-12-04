defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03
  import AdventUtils

  @input to_list("./inputs/day03.txt", [index: true])

  test "part1" do
    assert part1(@input) == 200
  end

  test "part2" do
    assert part2(@input) == 3737923200
  end
end
