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

  def nearby?({x1, y1, z1}, {x2, y2, z2}), do: abs(x1 - x2) <= 1 && abs(y1 - y2) <= 1 && abs(z1 - z2) <= 1

  def black?(tiles, min..max), do: fn tile ->
    Enum.reduce_while(
      tiles,
      0,
      fn x, acc ->
        if x != tile && nearby?(x, tile),
           do: {(if acc + 1 > max, do: :halt, else: :cont), acc + 1},
           else: {:cont, acc}
      end
    ) in min..max
  end

  defp expand(tiles), do:
    MapSet.new(Enum.flat_map(tiles, fn tile -> Enum.map([:e, :w, :nw, :ne, :sw, :se], &(offset(&1, tile))) end))

  defp cycle(tiles, 0), do: Enum.count(tiles)

  defp cycle(tiles, i), do: cycle(
    MapSet.new(Enum.filter(expand(tiles), black?(tiles, 2..2)) ++ Enum.filter(tiles, black?(tiles, 1..2))),
    i - 1
  )

  def part2(input), do:
    map_tiles(input)
    |> Enum.reduce([], fn {tile, black?}, acc -> if black?, do: [tile | acc], else: acc end)
    |> MapSet.new
    |> cycle(100)
end