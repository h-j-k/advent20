defmodule AdventOfCode.Day20 do
  @moduledoc "Day 20"

  defmodule Tile do
    defstruct id: nil, content: [], sides: []

    def new(id, content) do
      sides = [
        hd(content),
        Enum.join(Enum.map(content, &String.first/1)),
        Enum.join(Enum.map(content, &String.last/1)),
        hd(Enum.reverse(content))
      ]
      %Tile{id: id, content: content, sides: sides}
    end

    def align?(tile, other) do
      tile_sides = Enum.flat_map(tile.sides, &([&1, String.reverse(&1)]))
      other_sides = Enum.flat_map(other.sides, &([&1, String.reverse(&1)]))
      tile.id != other.id && Enum.any?(tile_sides, &(&1 in other_sides))
    end
  end

  defp parse_tile(tile) do
    [_, id] = Regex.run(~r/^Tile (\d+):$/, hd(tile))
    Tile.new(String.to_integer(id), tl(tile))
  end

  defp process_tiles(input) do
    tiles = Enum.map(input, &parse_tile/1)
    Map.new(tiles, fn tile -> {tile, MapSet.new(Enum.filter(tiles, &(Tile.align?(tile, &1))))} end)
  end

  def part1(input), do:
    process_tiles(input)
    |> Enum.filter(fn {_, matches} -> Enum.count(matches) == 2 end)
    |> Enum.reduce(1, &(elem(&1, 0).id * &2))

  defp to_row(tile, row, size, by_links, tiles, last_row) do
    has_side? = fn t, n -> Enum.any?(by_links[n], &(&1 == t)) end
    Enum.reverse(
      Enum.reduce(
        1..(size - 1),
        [tile],
        fn col, [last | rest] ->
          next = cond do
            has_side?.(last, 2) ->
              if row == 0,
                 do: Enum.at(tiles[last], 0),
                 else: Enum.find(tiles[last], &(&1 != Enum.at(last_row, 0)))
            has_side?.(last, 3) ->
              if row == 0 || row == size - 1,
                 do: Enum.find(tiles[last], &(&1 != hd(rest) && !has_side?.(&1, 4))),
                 else: Enum.find(tiles[last], &(has_side?.(&1, 4)))
            has_side?.(last, 4) ->
              Enum.find(
                MapSet.intersection(tiles[last], tiles[Enum.at(last_row, col)]),
                &(&1 != Enum.at(last_row, col - 1))
              )
          end
          [next, last | rest]
        end
      )
    )
  end

  def part2(input) do
    tiles = process_tiles(input)
    size = floor(:math.sqrt(Enum.count(tiles)))
    by_links = Map.new(
      Enum.group_by(tiles, fn {_, matches} -> Enum.count(matches) end),
      fn {n, v} -> {n, Enum.map(v, &(elem(&1, 0)))} end
    )
    grid = Enum.reduce(
      1..(size - 1),
      [to_row(hd(by_links[2]), 0, size, by_links, tiles, [])],
      fn row, [last_row | rest] ->
        others = if row == 1, do: [], else: [Enum.at(hd(rest), 0)]
        tile = Enum.find(tiles[hd(last_row)], &(!(&1 in [Enum.at(last_row, 1) | others])))
        r = to_row(tile, row, size, by_links, tiles, last_row)
        [r, last_row | rest]
      end
    )
    Enum.each(grid, fn row -> IO.puts(inspect(Enum.map(row, &(&1.id)))) end)
    0
  end
end