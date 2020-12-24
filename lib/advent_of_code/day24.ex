defmodule AdventOfCode.Day24 do
  @moduledoc "Day 24"

  defp parse(line), do:
    Enum.map(Regex.scan(~r/([ns]?[ew])/, line), fn [x, _] -> String.to_atom(x) end)

  defp offset(:e, {x, y, z}), do: {x + 1, y - 1, z}
  defp offset(:w, {x, y, z}), do: {x - 1, y + 1, z}
  defp offset(:nw, {x, y, z}), do: {x, y + 1, z - 1}
  defp offset(:ne, {x, y, z}), do: {x + 1, y, z - 1}
  defp offset(:sw, {x, y, z}), do: {x - 1, y, z + 1}
  defp offset(:se, {x, y, z}), do: {x, y - 1, z + 1}

  defp shift(moves), do: Enum.reduce(moves, {0, 0, 0}, &offset/2)

  defp map_tiles(input), do:
    Enum.reduce(input, %{}, fn line, map -> Map.update(map, shift(parse(line)), true, &(!&1)) end)

  def part1(input), do: Enum.count(map_tiles(input), fn {_, black?} -> black? end)

  def black?(active, size), do: fn tile ->
    zipped = &(Enum.zip(Tuple.to_list(&1), Tuple.to_list(tile)))
    Enum.count(active, &(&1 != tile && Enum.all?(zipped.(&1), fn {a, b} -> abs(a - b) <= 1 end))) in size
  end

  @neighbors [:e, :w, :nw, :ne, :sw, :se]

  defp cycle(tiles, 0), do: Enum.count(tiles)

  defp cycle(tiles, i), do: cycle(
    MapSet.new(
      Enum.filter(
        MapSet.new(Enum.flat_map(tiles, fn tile -> Enum.map(@neighbors, &(offset(&1, tile))) end)),
        black?(tiles, [2])
      )
      ++ Enum.filter(tiles, black?(tiles, 1..2))
    ),
    i - 1
  )

  def part2(input), do:
    map_tiles(input)
    |> Enum.reduce([], fn {tile, black?}, acc -> if black?, do: [tile | acc], else: acc end)
    |> MapSet.new
    |> cycle(100)
end