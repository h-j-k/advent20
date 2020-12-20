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

  defp process_tiles(input) do
    tiles = Enum.map(input, &parse_tile/1)
    Map.new(
      tiles,
      fn {id, sides} ->
        aligns? = fn {tile_id, tile_sides} -> tile_id != id && Enum.any?(sides, &(&1 in tile_sides)) end
        {{id, sides}, Enum.filter(tiles, aligns?)}
      end
    )
  end

  def part1(input) do
    tiles = process_tiles(input)
    Enum.reduce(
      Enum.filter(tiles, fn {_, matches} -> Enum.count(matches) == 2 end),
      1,
      fn {{id, _}, _}, acc -> id * acc end
    )
  end

  def part2(input) do
    0
  end
end