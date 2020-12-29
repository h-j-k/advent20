defmodule AdventOfCode.Day20 do
  @moduledoc "Day 20"

  defmodule Tile do
    defstruct id: nil, area: [], sides: []

    def new(id, area) do
      sides = [
        hd(area),
        Enum.join(Enum.map(area, &String.first/1)),
        Enum.join(Enum.map(area, &String.last/1)),
        Enum.at(area, -1)
      ]
      %Tile{id: id, area: area, sides: Enum.flat_map(sides, &([&1, String.reverse(&1)]))}
    end

    def align?(tile, other), do: tile.id != other.id && Enum.any?(tile.sides, &(&1 in other.sides))
  end

  defp parse_tile(tile), do:
    (fn [_, id] -> Tile.new(String.to_integer(id), tl(tile)) end).(Regex.run(~r/^Tile (\d+):$/, hd(tile)))

  defp process_tiles(input) do
    tiles = Enum.map(input, &parse_tile/1)
    Map.new(tiles, fn tile -> {tile, MapSet.new(Enum.filter(tiles, &(Tile.align?(tile, &1))))} end)
  end

  defp to_row(tile, row, size, has_side?, tiles, last_row), do: Enum.reduce(
    1..(size - 1),
    [tile],
    fn col, [last | rest] ->
      next = cond do
        has_side?.(last, 2) ->
          Enum.find(tiles[last], &(row == 0 || &1 != Enum.at(last_row, 0)))
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

  defp to_grid(input) do
    tiles = process_tiles(input)
    size = floor(:math.sqrt(Enum.count(tiles)))
    by_links = Map.new(
      Enum.group_by(tiles, fn {_, matches} -> Enum.count(matches) end),
      fn {n, v} -> {n, Enum.map(v, &(elem(&1, 0)))} end
    )
    has_side? = fn t, n -> Enum.any?(by_links[n], &(&1 == t)) end
    Enum.reduce(
      1..(size - 1),
      [Enum.reverse(to_row(hd(by_links[2]), 0, size, has_side?, tiles, []))],
      fn row, [last_row | rest] ->
        others = if row == 1, do: [], else: [Enum.at(hd(rest), 0)]
        tile = Enum.find(tiles[hd(last_row)], &(!(&1 in [Enum.at(last_row, 1) | others])))
        [Enum.reverse(to_row(tile, row, size, has_side?, tiles, last_row)), last_row | rest]
      end
    )
  end

  defp options(tile) when is_struct(tile) do
    flip_ew = fn area -> Enum.map(area, &String.reverse/1) end
    flip_ns = fn area -> Enum.reverse(area) end
    rotate = fn area ->
      size = length(area) - 1
      Enum.map(0..size, fn x -> Enum.join(Enum.map(size..0, &(String.at(Enum.at(area, &1), x)))) end)
    end
    area = tile.area
    [
      area,
      flip_ew.(area),
      flip_ns.(area),
      rotate.(area),
      flip_ew.(rotate.(area)),
      flip_ns.(rotate.(area)),
      rotate.(rotate.(area)),
      rotate.(rotate.(rotate.(area)))
    ]
  end

  defp options(area) when is_list(area), do: [area, Enum.reverse(area)]

  defp match({first, map_first}, {second, map_second}), do: Enum.find_value(
    first,
    fn a -> Enum.find_value(second, fn b -> if map_first.(a) == map_second.(b), do: {a, b}, else: nil end) end
  )

  defp match_tile(second, first) do
    right = fn area -> Enum.join(Enum.map(area, &String.last/1)) end
    left = fn area -> Enum.join(Enum.map(area, &String.first/1)) end
    {a, b} = match({first, right}, {second, left})
    [Enum.map(Enum.zip(a, b), fn {x, y} -> String.slice(x, 0..-2) <> String.slice(y, 1..-1) end)]
  end

  defp match_row(second, first) do
    {a, b} = match({first, &(Enum.at(&1, -1))}, {second, &(hd(&1))})
    [Enum.concat(Enum.drop(a, -1), tl(b))]
  end

  defp combine(list, mapper, combiner) do
    [a, b | rest] = Enum.map(list, &(options(mapper.(&1))))
    hd(Enum.reduce(rest, combiner.(b, a), combiner))
  end

  defp to_sea(input), do:
    combine(to_grid(input), fn row -> combine(row, &(&1), &match_tile/2) end, &match_row/2)
    |> Enum.slice(1..-2)
    |> Enum.map(&(String.slice(&1, 1..-2)))

  @shapes [~r/^..................#.$/, ~r/^#....##....##....###$/, ~r/^.#..#..#..#..#..#...$/]

  defp count_monsters_in(lines), do: Enum.reduce(
    0..(String.length(hd(lines)) - 20),
    0,
    fn x, acc ->
      if Enum.all?(Enum.zip(@shapes, lines), &(Regex.match?(elem(&1, 0), String.slice(elem(&1, 1), x, 20)))),
         do: acc + 1,
         else: acc
    end
  )

  def part1(input), do:
    process_tiles(input)
    |> Enum.filter(fn {_, matches} -> Enum.count(matches) == 2 end)
    |> Enum.reduce(1, &(elem(&1, 0).id * &2))

  def part2(input) do
    sea = to_sea(input)
    Enum.find_value(
      options(Tile.new(0, sea)),
      fn x ->
        case Enum.reduce(0..(length(x) - 3), 0, &(count_monsters_in(Enum.slice(x, &1, 3)) + &2)) do
          0 -> nil
          n -> Enum.reduce(sea, 0, &(Enum.count(String.graphemes(&1), fn x -> x == "#" end) + &2)) - n * 15
        end
      end
    )
  end
end