defmodule AdventOfCode.Day20 do
  @moduledoc "Day 20"

  defp parse_tile(tile) do
    id = (&(Enum.at(&1, 1))).(Regex.run(~r/^Tile (\d+):$/, hd(tile)))
    {content, size} = (&({&1, length(&1)})).(tl(tile))
    sides = Enum.flat_map(
      [
        hd(content),
        Enum.join(Enum.map(content, &String.first/1)),
        Enum.join(Enum.map(content, &String.last/1)),
        Enum.at(content, size - 1)
      ],
      &([&1, String.reverse(&1)])
    )
    {String.to_integer(id), sides}
  end

  def part1(input) do
    tiles = Enum.map(input, &parse_tile/1)
    corners = Enum.filter(
      tiles,
      fn {id, sides} ->
        aligns? = fn {tile_id, tile_sides} -> tile_id != id && Enum.any?(sides, &(&1 in tile_sides)) end
        Enum.count(tiles, aligns?) == 2
      end
    )
    Enum.reduce(corners, 1, fn {id, _}, acc -> id * acc end)
  end

  def part2(input) do
    0
  end
end