defmodule AdventOfCode.Day11 do
  @moduledoc "Day 11"

  defmodule Seat, do: defstruct x: 0, y: 0, empty?: true

  defmodule SeatMap do
    defstruct by_row: %{}, neighbors: %{}

    def new(by_row, neighbors) when is_function(neighbors), do: %SeatMap{
      by_row: by_row,
      neighbors: Map.new(Enum.flat_map(by_row, &(Enum.map(elem(&1, 1), neighbors.(by_row, elem(&1, 1))))))
    }

    def new(by_row, neighbors) when is_map(neighbors), do: %SeatMap{by_row: by_row, neighbors: neighbors}
  end

  defp parse(list), do: Map.new(
    Enum.map(
      list,
      fn {line, index} ->
        seats = Enum.map(
          Enum.with_index(String.graphemes(line)),
          fn {cell, col} -> if cell == "L", do: %Seat{x: col, y: index}, else: nil end
        )
        {index, Enum.filter(seats, &(&1 != nil))}
      end
    )
  )

  defp update(seat_map, threshold), do: fn {row, row_seats} ->
    updated = Enum.map(
      row_seats,
      fn seat ->
        occupied = Enum.reduce_while(
          seat_map.neighbors[{seat.x, seat.y}],
          0,
          fn {x, y}, acc ->
            case Enum.find(Map.get(seat_map.by_row, y, []), &(&1.x == x)) do
              nil -> {:cont, acc}
              s when seat.empty? and not s.empty? -> {:halt, threshold}
              s when seat.empty? == s.empty? and acc + 1 == threshold -> {:halt, threshold}
              s when not s.empty? -> {:cont, acc + 1}
              s when s.empty? -> {:cont, acc}
            end
          end
        )
        is_empty = case occupied do
          0 when seat.empty? -> false
          n when n >= threshold and not seat.empty? -> true
          _ -> seat.empty?
        end
        %Seat{x: seat.x, y: seat.y, empty?: is_empty}
      end
    )
    {row, updated}
  end

  defp process(list, neighbors, threshold) do
    process = &(SeatMap.new(Map.new(&1.by_row, update(&1, threshold)), &1.neighbors))
    Stream.unfold(
      SeatMap.new(parse(list), neighbors),
      fn current ->
        next = process.(current)
        if next == current, do: nil, else: {current, next}
      end
    )
    |> Enum.at(-1)
    |> (&(process.(&1).by_row)).()
    |> Enum.reduce(0, fn {_, row_seats}, acc -> acc + Enum.count(row_seats, &(&1 != nil && !&1.empty?)) end)
  end

  @immediate [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]

  defp part_one_neighbors(_, _), do: fn seat ->
    {{seat.x, seat.y}, Enum.map(@immediate, fn {x, y} -> {seat.x + x, seat.y + y} end)}
  end

  defp part_two_neighbors(by_row, row_seats), do: fn seat ->
    neighbors = case Enum.find_index(row_seats, &(&1.x == seat.x)) do
      0 -> [Enum.at(row_seats, 1)]
      n -> Enum.map([-1, 1], &(Enum.at(row_seats, n + &1)))
    end
    Enum.flat_map(
      by_row,
      fn r -> Enum.filter(elem(r, 1), &(seat.x == &1.x || abs(seat.x - &1.x) == abs(seat.y - &1.y))) end
    )
    |> Enum.sort_by(&(abs(seat.y - &1.y)))
    |> Enum.reduce_while(
         [nil, nil, nil, nil, nil, nil],
         fn a, [n, s, nw, ne, se, sw] ->
           positions = cond do
             a.x == seat.x && a.y < seat.y && n == nil -> [a, s, nw, ne, se, sw]
             a.x == seat.x && a.y > seat.y && s == nil -> [n, a, nw, ne, se, sw]
             a.x < seat.x && a.y < seat.y && nw == nil -> [n, s, a, ne, se, sw]
             a.x > seat.x && a.y < seat.y && ne == nil -> [n, s, nw, a, se, sw]
             a.x > seat.x && a.y > seat.y && se == nil -> [n, s, nw, ne, a, sw]
             a.x < seat.x && a.y > seat.y && sw == nil -> [n, s, nw, ne, se, a]
             true -> [n, s, nw, ne, se, sw]
           end
           {(if Enum.any?(positions, &(&1 == nil)), do: :cont, else: :halt), positions}
         end
       )
    |> (fn rest -> Enum.filter(rest ++ neighbors, &(&1 != nil)) end).()
    |> (fn positions -> {{seat.x, seat.y}, Enum.map(positions, &({&1.x, &1.y}))} end).()
  end

  def part1(list), do: process(list, &part_one_neighbors/2, 4)

  def part2(list), do: process(list, &part_two_neighbors/2, 5)
end