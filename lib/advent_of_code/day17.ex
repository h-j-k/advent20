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

  defp neighbor?(cube, other) do
    cube != other && Enum.all?(Enum.zip(Tuple.to_list(cube), Tuple.to_list(other)), fn {a, b} -> abs(a - b) <= 1 end)
  end

  defp part1_expansion({x0, y0, z0}) do
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

  defp part2_expansion({x0, y0, z0, w0}) do
    Enum.flat_map(
      -1..1,
      fn x ->
        Enum.flat_map(
          -1..1,
          fn y ->
            Enum.flat_map(
              -1..1,
              fn z -> Enum.map(-1..1, fn w -> {x0 + x, y0 + y, z0 + z, w0 + w} end) end
            )
          end
        )
      end
    ) -- [{x0, y0, z0, w0}]
  end

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

  defp process(input, to_cube, expansion) do
    Enum.count(Enum.reduce(1..6, parse(input, to_cube), fn _, prev -> process(prev, expansion) end))
  end

  def part1(input), do: process(input, &({&1, &2, 0}), &part1_expansion/1)

  def part2(input), do: process(input, &({&1, &2, 0, 0}), &part2_expansion/1)
end