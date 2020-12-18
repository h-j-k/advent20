defmodule AdventOfCode.Day17 do
  @moduledoc "Day 17"

  defp flattened_set(enum), do: MapSet.new(Enum.flat_map(enum, &(elem(&1, 1))))

  def nearby?(active, size), do: fn cube ->
    zipped = &(Enum.zip(Tuple.to_list(&1), Tuple.to_list(cube)))
    Enum.count(active, &(&1 != cube && Enum.all?(zipped.(&1), fn {a, b} -> abs(a - b) <= 1 end))) in size
  end

  defp cycle(_, active), do: MapSet.new(
    Enum.filter(flattened_set(Enum.map(active, AdventOfCode.expand())), nearby?(active, [3]))
    ++ Enum.filter(active, nearby?(active, 2..3))
  )

  defp process(input, mapper), do:
    Enum.count(Enum.reduce(1..6, flattened_set(AdventOfCode.from(input, "#", mapper)), &cycle/2))

  def part1(input), do: process(input, &({&1, &2, 0}))

  def part2(input), do: process(input, &({&1, &2, 0, 0}))
end