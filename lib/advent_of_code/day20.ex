defmodule AdventOfCode.Day20 do
  @moduledoc "Day 20"

  defmodule Tile do
    defstruct id: nil, content: [], sides: []

    def new(id, content) do
      sides = [
        hd(content),
        Enum.join(Enum.map(content, &String.first/1)),
        Enum.join(Enum.map(content, &String.last/1)),
        Enum.at(content, -1)
      ]
      %Tile{id: id, content: content, sides: Enum.flat_map(sides, &([&1, String.reverse(&1)]))}
    end

    def align?(tile, other), do: tile.id != other.id && Enum.any?(tile.sides, &(&1 in other.sides))
  end

  defp parse_tile(tile) do
    [_, id] = Regex.run(~r/^Tile (\d+):$/, hd(tile))
    Tile.new(String.to_integer(id), tl(tile))
  end

  defp process_tiles(input) do
    tiles = Enum.map(input, &parse_tile/1)
    Map.new(tiles, fn tile -> {tile, MapSet.new(Enum.filter(tiles, &(Tile.align?(tile, &1))))} end)
  end

  defp to_row(tile, row, size, has_side?, tiles, last_row), do:
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
    |> Enum.reverse

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
    flip_ew = fn content -> Enum.map(content, &String.reverse/1) end
    flip_ns = fn content -> Enum.reverse(content) end
    rotate = fn content ->
      size = length(content) - 1
      Enum.map(0..size, fn x -> Enum.join(Enum.map(size..0, &(String.at(Enum.at(content, &1), x)))) end)
    end
    content = tile.content
    [
      content,
      flip_ew.(content),
      flip_ns.(content),
      rotate.(content),
      flip_ew.(rotate.(content)),
      flip_ns.(rotate.(content)),
      rotate.(rotate.(content)),
      rotate.(rotate.(rotate.(content)))
    ]
  end

  defp options(content) when is_list(content), do: [content, Enum.reverse(content)]

  defp match_tile(first, second) do
    right = fn content -> Enum.join(Enum.map(content, &String.last/1)) end
    left = fn content -> Enum.join(Enum.map(content, &String.first/1)) end
    a = if Enum.count(first) == 1,
           do: hd(first),
           else: Enum.find(first, fn x -> Enum.any?(second, &(right.(x) == left.(&1))) end)
    b = Enum.find(second, &(right.(a) == left.(&1)))
    Enum.map(0..(length(a) - 1), fn i -> Enum.at(a, i) <> Enum.at(b, i) end)
  end

  defp match_row(first, second) do
    bottom = fn content -> Enum.at(content, -1) end
    top = fn content -> hd(content) end
    a = if Enum.count(first) == 1,
           do: hd(first),
           else: Enum.find(first, fn x -> Enum.any?(second, &(bottom.(x) == top.(&1))) end)
    Enum.concat(a, Enum.find(second, &(bottom.(a) == top.(&1))))
  end

  defp to_sea(grid), do: Enum.reduce(
    Enum.with_index(grid),
    [],
    fn {row, y}, sea ->
      row_content = Enum.reduce(
        Enum.with_index(row),
        [],
        fn
          {tile, 1}, _ -> match_tile(options(hd(row)), options(tile))
          {tile, n}, content when n > 1 -> match_tile([content], options(tile))
          _, content -> content
        end
      )
      case y do
        1 -> match_row(options(sea), options(row_content))
        n when n > 1 -> match_row([sea], options(row_content))
        _ -> row_content
      end
    end
  )

  defp remove_borders(line, size) when is_binary(line), do:
    String.graphemes(line)
    |> Enum.with_index
    |> Enum.filter(fn {_, c} -> rem(c, size) != 0 && rem(c + 1, size) != 0 end)
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.join

  defp remove_borders(sea, size) when is_list(sea), do:
    Enum.with_index(sea)
    |> Enum.reduce(
         [],
         fn {line, r}, acc ->
           if rem(r, size) == 0 || rem(r + 1, size) == 0, do: acc, else: [remove_borders(line, size) | acc]
         end
       )
    |> Enum.reverse

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

  defp count_monsters_for(sea), do:
    0..(length(sea) - 3)
    |> Enum.reduce(0, &(count_monsters_in(Enum.slice(sea, &1, 3)) + &2))
    |> (&(if &1 == 0, do: nil, else: &1)).()

  defp count_monsters_all(sea_tile), do:
    Enum.find_value(options(sea_tile), &(count_monsters_for(&1)))

  defp count_fills(sea), do:
    Enum.sum(Enum.map(sea, &(Enum.count(String.graphemes(&1), fn x -> x == "#" end))))

  def part1(input), do:
    process_tiles(input)
    |> Enum.filter(fn {_, matches} -> Enum.count(matches) == 2 end)
    |> Enum.reduce(1, &(elem(&1, 0).id * &2))

  def part2(input) do
    grid = to_grid(input)
    sea = remove_borders(to_sea(grid), length(hd(hd(grid)).content))
    count_fills(sea) - (count_monsters_all(Tile.new(0, sea)) * 15)
  end
end