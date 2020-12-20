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
    Map.new(tiles, fn tile -> {tile, Enum.filter(tiles, &(Tile.align?(tile, &1)))} end)
  end

  def part1(input), do:
    process_tiles(input)
    |> Enum.filter(fn {_, matches} -> Enum.count(matches) == 2 end)
    |> Enum.reduce(1, &(elem(&1, 0).id * &2))

  defp desc(by_links), do: Enum.each(
    by_links,
    fn {n, ts} ->
      IO.puts(
        "By #{n} links:\n\t#{
          Enum.join(
            Enum.map(ts, fn {t, x} -> "#{t.id} => #{Enum.join(Enum.map(x, &(Integer.to_string(&1.id))), ", ")}" end),
            "\n\t"
          )
        }"
      )
    end
  )

  def part2(input) do
    tiles = process_tiles(input)
    size = floor(:math.sqrt(Enum.count(tiles)))
    by_links = Enum.group_by(tiles, fn {_, matches} -> Enum.count(matches) end)
    desc(by_links)
    0
  end
end