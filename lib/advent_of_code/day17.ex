defmodule AdventOfCode.Day17 do
  @moduledoc "Day 17"

  defp flattened_set(enum), do: MapSet.new(Enum.flat_map(enum, &(elem(&1, 1))))

  def nearby?(active, min..max), do: fn cube ->
    zipped = &(Enum.zip(Tuple.to_list(&1), Tuple.to_list(cube)))
    Enum.reduce_while(
      active,
      0,
      fn x, acc ->
        if x != cube && Enum.all?(zipped.(x), fn {a, b} -> abs(a - b) <= 1 end),
           do: {(if acc + 1 > max, do: :halt, else: :cont), acc + 1},
           else: {:cont, acc}
      end
    ) in min..max
  end

  defp cycle(_, active), do: MapSet.new(
    Enum.filter(flattened_set(Enum.map(active, AdventOfCode.expand())), nearby?(active, 3..3))
    ++ Enum.filter(active, nearby?(active, 2..3))
  )

  defp process(input, mapper), do:
    Enum.count(Enum.reduce(1..6, flattened_set(AdventOfCode.from(input, "#", mapper)), &cycle/2))

  def part1(input), do: process(input, &({&1, &2, 0}))

  def part2(input), do: process(input, &({&1, &2, 0, 0}))
end