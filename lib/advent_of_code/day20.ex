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

  defp to_row(tile, row, size, has_side?, tiles, last_row), do: Enum.reverse(
    Enum.reduce(
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
      [to_row(hd(by_links[2]), 0, size, has_side?, tiles, [])],
      fn row, [last_row | rest] ->
        others = if row == 1, do: [], else: [Enum.at(hd(rest), 0)]
        tile = Enum.find(tiles[hd(last_row)], &(!(&1 in [Enum.at(last_row, 1) | others])))
        [to_row(tile, row, size, has_side?, tiles, last_row), last_row | rest]
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

  defp match_tile(first, second) do
    right = fn area -> Enum.join(Enum.map(area, &String.last/1)) end
    left = fn area -> Enum.join(Enum.map(area, &String.first/1)) end
    a = if Enum.count(first) == 1,
           do: hd(first),
           else: Enum.find(first, fn x -> Enum.any?(second, &(right.(x) == left.(&1))) end)
    b = Enum.find(second, &(right.(a) == left.(&1)))
    Enum.map(0..(length(a) - 1), fn i -> String.slice(Enum.at(a, i), 0..-2) <> String.slice(Enum.at(b, i), 1..-1) end)
  end

  defp match_row(first, second) do
    bottom = fn area -> Enum.at(area, -1) end
    top = fn area -> hd(area) end
    a = if Enum.count(first) == 1,
           do: hd(first),
           else: Enum.find(first, fn x -> Enum.any?(second, &(bottom.(x) == top.(&1))) end)
    Enum.concat(Enum.drop(a, -1), Enum.drop(Enum.find(second, &(bottom.(a) == top.(&1))), 1))
  end

  defp combine(list, mapper, combiner), do: Enum.reduce(
    Enum.with_index(list),
    nil,
    fn {x, i}, acc ->
      result = mapper.(x)
      case i do
        0 -> result
        1 -> combiner.(options(acc), options(result))
        _ -> combiner.([acc], options(result))
      end
    end
  )

  defp to_sea(input) do
    sea = combine(to_grid(input), fn row -> combine(row, &(&1), &match_tile/2) end, &match_row/2)
          |> Enum.slice(1..-2)
          |> Enum.map(&(String.slice(&1, 1..-2)))
    {sea, Enum.reduce(sea, 0, &(Enum.count(String.graphemes(&1), fn x -> x == "#" end) + &2))}
  end

  @shapes %{0 => ~r/^..................#.$/, 1 => ~r/^#....##....##....###$/, 2 => ~r/^.#..#..#..#..#..#...$/}

  defp count_monsters_in(lines), do: Enum.reduce(
    0..(String.length(hd(lines)) - 20),
    0,
    fn x, acc ->
      if Enum.all?(@shapes, fn {index, regex} -> Regex.match?(regex, String.slice(Enum.at(lines, index), x, 20)) end),
         do: acc + 1,
         else: acc
    end
  )

  defp count_monsters(tile), do: Enum.find_value(
    options(tile),
    fn sea ->
      case Enum.reduce(0..(length(sea) - 3), 0, &(count_monsters_in(Enum.slice(sea, &1, 3)) + &2)) do
        0 -> nil
        n -> n
      end
    end
  )

  def part1(input), do:
    process_tiles(input)
    |> Enum.filter(fn {_, matches} -> Enum.count(matches) == 2 end)
    |> Enum.reduce(1, &(elem(&1, 0).id * &2))

  def part2(input), do:
    (fn {sea, fills} -> fills - (count_monsters(Tile.new(0, sea)) * 15) end).(to_sea(input))
end