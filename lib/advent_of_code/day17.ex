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

  defp nearby(cubes, cube), do: Enum.count(
    cubes,
    &(&1 != cube && Enum.all?(Enum.zip(Tuple.to_list(&1), Tuple.to_list(cube)), fn {a, b} -> abs(a - b) <= 1 end))
  )

  defp expand(mapper), do: fn acc -> Enum.flat_map(-1..1, &(mapper.([&1 | acc]))) end

  defp expand(d, mapper), do: Enum.reduce(1..d, mapper, fn _, acc -> expand(acc) end).([])

  defp process(cubes, expansion), do: MapSet.new(
    Enum.filter(flattened_set(cubes, expansion), &(!(&1 in cubes) && nearby(cubes, &1) == 3))
    ++ Enum.filter(cubes, &(nearby(cubes, &1) in 2..3))
  )

  defp process(input, to_cube, expansion), do:
    Enum.count(Enum.reduce(1..6, parse(input, to_cube), fn _, last -> process(last, expansion) end))

  def part1(input), do: process(
    input,
    &({&1, &2, 0}),
    fn {x0, y0, z0} -> expand(3, fn [z, y, x] -> [{x0 + x, y0 + y, z0 + z}] end) end
  )

  def part2(input), do: process(
    input,
    &({&1, &2, 0, 0}),
    fn {x0, y0, z0, w0} -> expand(4, fn [w, z, y, x] -> [{x0 + x, y0 + y, z0 + z, w0 + w}] end) end
  )
end