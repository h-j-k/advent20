defmodule AdventOfCode.Day17 do
  @moduledoc "Day 17"

  defp flattened_set(enum, mapper), do: MapSet.new(Enum.flat_map(enum, mapper))

  defp parse(input, to_cube), do: flattened_set(
    input,
    fn {line, y} ->
      Enum.flat_map(
        Enum.with_index(String.graphemes(line)),
        fn {cell, x} -> if cell == "#", do: [to_cube.(x, y)], else: [] end
      )
    end
  )

  def nearby?(active, size), do: fn cube ->
    Enum.count(active, &(&1 != cube && Enum.all?(Enum.zip(&1, cube), fn {a, b} -> abs(a - b) <= 1 end))) in size
  end

  defp expand(), do: fn point ->
    Enum.reduce(
      1..length(point),
      &([Enum.map(Enum.zip(point, &1), fn {p, d} -> p + d end)]),
      fn _, mapper -> &(Enum.flat_map(-1..1, fn d -> mapper.([d | &1]) end)) end
    ).([]) -- [point]
  end

  defp cycle(_, active), do: MapSet.new(
    Enum.filter(flattened_set(active, expand()), nearby?(active, [3])) ++ Enum.filter(active, nearby?(active, 2..3))
  )

  defp process(start), do: Enum.count(Enum.reduce(1..6, start, &cycle/2))

  def part1(input), do: process(parse(input, &([&1, &2, 0])))

  def part2(input), do: process(parse(input, &([&1, &2, 0, 0])))
end