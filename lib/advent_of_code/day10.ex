defmodule AdventOfCode.Day10 do
  @moduledoc "Day 10"

  def part1(list) do
    reducer = fn x, {diffs, last} -> {Map.update(diffs, x - last, 1, &(&1 + 1)), x} end
    (fn {diffs, _} -> diffs[1] * diffs[3] end).(Enum.reduce(Enum.sort(list), {%{3 => 1}, 0}, reducer))
  end

  def part2(list) do
    reducer = fn x, acc -> Map.put(acc, x, Enum.reduce(1..3, 0, &(&2 + Map.get(acc, x - &1, 0)))) end
    elem(Enum.max_by(Enum.reduce(Enum.sort(list), %{0 => 1}, reducer), &(elem(&1, 0))), 1)
  end
end