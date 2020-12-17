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

  defp neighbor?(cube, other), do:
    cube != other && Enum.all?(Enum.zip(Tuple.to_list(cube), Tuple.to_list(other)), fn {a, b} -> abs(a - b) <= 1 end)

  defp expand(mapper), do: fn acc -> Enum.flat_map(-1..1, &(mapper.([&1 | acc]))) end

  defp part1_expansion({x0, y0, z0}), do:
    expand(expand(expand(fn [z, y, x] -> [{x0 + x, y0 + y, z0 + z}] end))).([])

  defp part2_expansion({x0, y0, z0, w0}), do:
    expand(expand(expand(expand(fn [w, z, y, x] -> [{x0 + x, y0 + y, z0 + z, w0 + w}] end)))).([])

  defp process(cubes, expansion) do
    still_active = Enum.map(cubes, fn cube -> {cube, Enum.filter(cubes, &(neighbor?(cube, &1)))} end)
                   |> Enum.filter(fn {_, neighbors} -> Enum.count(neighbors) in 2..3 end)
                   |> Enum.map(&(elem(&1, 0)))
    new_active = Enum.filter(
      flattened_set(cubes, expansion),
      fn cube -> !(cube in cubes) && Enum.count(cubes, &(neighbor?(cube, &1))) == 3 end
    )
    MapSet.new(still_active ++ new_active)
  end

  defp process(input, to_cube, expansion), do:
    Enum.count(Enum.reduce(1..6, parse(input, to_cube), fn _, last -> process(last, expansion) end))

  def part1(input), do: process(input, &({&1, &2, 0}), &part1_expansion/1)

  def part2(input), do: process(input, &({&1, &2, 0, 0}), &part2_expansion/1)
end