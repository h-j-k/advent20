defmodule AdventOfCode.Day17 do
  @moduledoc "Day 17"

  defp flattened_set(enum, mapper), do: MapSet.new(Enum.flat_map(enum, mapper))

  defp parse(input), do: flattened_set(
    input,
    fn {line, y} ->
      Enum.flat_map(
        Enum.with_index(String.graphemes(line)),
        fn {cell, x} -> if cell == "#", do: [{x, y, 0}], else: [] end
      )
    end
  )

  defp neighbor?(cube, other) do
    cube != other && Enum.all?(Enum.zip(Tuple.to_list(cube), Tuple.to_list(other)), fn {a, b} -> abs(a - b) <= 1 end)
  end

  defp expand({x0, y0, z0}) do
    Enum.flat_map(
      -1..1,
      fn x ->
        Enum.flat_map(
          -1..1,
          fn y -> Enum.map(-1..1, fn z -> {x0 + x, y0 + y, z0 + z} end)
          end
        )
      end
    ) -- [{x0, y0, z0}]
  end

  defp process(cubes) do
    still_active = Enum.map(cubes, fn cube -> {cube, Enum.filter(cubes, &(neighbor?(cube, &1)))} end)
                   |> Enum.filter(fn {_, neighbors} -> Enum.count(neighbors) in 2..3 end)
                   |> Enum.map(&(elem(&1, 0)))
    new_active = Enum.filter(
      flattened_set(cubes, &expand/1),
      fn cube -> !(cube in cubes) && Enum.count(cubes, &(neighbor?(cube, &1))) == 3 end
    )
    MapSet.new(still_active ++ new_active)
  end

  def part1(input) do
    Enum.count(Enum.reduce(1..6, parse(input), fn _, prev -> process(prev) end))
  end

  def part2(input) do
    0
  end
end