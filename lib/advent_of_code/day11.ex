defmodule AdventOfCode.Day11 do
  @moduledoc "Day 11"

  defmodule Seat, do: defstruct x: 0, y: 0, empty?: true

  defmodule SeatMap do
    defstruct seats: MapSet.new(), row: %{}, neighbors: %{}

    def new(seats, neighbors) do
      by_row = Map.new(
        Enum.group_by(seats, &(&1.y)),
        fn {k, v} -> {k, Enum.sort_by(v, &(&1.x))} end
      )
      %SeatMap{
        seats: seats,
        row: by_row,
        neighbors: (if is_map(neighbors), do: neighbors, else: Map.new(neighbors.(by_row)))
      }
    end
  end

  defp parse(list) do
    list
    |> Enum.flat_map(
         fn {line, index} ->
           String.graphemes(line)
           |> Enum.with_index
           |> Enum.map(fn {cell, col} -> if cell == "L", do: %Seat{x: col, y: index}, else: nil end)
           |> Enum.filter(&(&1 != nil))
         end
       )
    |> MapSet.new
  end

  defp occupied(seats), do: Enum.count(seats, &(&1 != nil && !&1.empty?))

  defp run(seat_map, threshold), do: fn seat ->
    occupied = Enum.reduce_while(
      seat_map.neighbors[{seat.x, seat.y}],
      0,
      fn {x, y}, acc ->
        case Enum.find(Map.get(seat_map.row, y, []), &(&1.x == x)) do
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

  defp process(list, neighbors, threshold) do
    process = &(SeatMap.new(MapSet.new(&1.seats, run(&1, threshold)), &1.neighbors))
    r = Enum.at(
      Stream.unfold(
        SeatMap.new(parse(list), neighbors),
        fn current ->
          next = process.(current)
          if next == current, do: nil, else: {current, next}
        end
      ),
      -1
    )
    occupied(process.(r).seats)
  end

  defp part_one_neighbors(by_row) do
    Enum.flat_map(
      by_row,
      fn {_, row_seats} ->
        Enum.map(
          row_seats,
          fn seat ->
            {
              {seat.x, seat.y},
              Enum.map(
                [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}],
                fn {x, y} -> {seat.x + x, seat.y + y} end
              )
            }
          end
        )
      end
    )
  end

  def part1(list), do: process(list, &part_one_neighbors/1, 4)

  defp part_two_neighbors(by_row) do
    seats = Enum.flat_map(by_row, &(elem(&1, 1)))
    by_col = Map.new(
      Enum.group_by(seats, &(&1.x)),
      fn {k, v} -> {k, Enum.sort_by(v, &(&1.y))} end
    )
    neighbors = fn line, finder ->
      case Enum.find_index(line, finder) do
        0 -> [Enum.at(line, 1)]
        n -> Enum.map([-1, 1], &(Enum.at(line, n + &1)))
      end
    end
    Enum.flat_map(
      by_row,
      fn {_, row_seats} ->
        Enum.map(
          row_seats,
          fn seat ->
            horizontal = neighbors.(row_seats, &(&1.x == seat.x))
            vertical = neighbors.(by_col[seat.x], &(&1.y == seat.y))
            mapper = fn positions ->
              {{seat.x, seat.y}, Enum.map(Enum.filter(positions, &(&1 != nil)), fn s -> {s.x, s.y} end)}
            end
            Enum.filter(seats, &(abs(seat.x - &1.x) - abs(seat.y - &1.y) == 0))
            |> Enum.sort_by(&(abs(seat.x - &1.x)))
            |> Enum.reduce_while(
                 [nil, nil, nil, nil],
                 fn s, [nw, ne, se, sw] ->
                   updated = cond do
                     s.x < seat.x && s.y < seat.y && nw == nil -> [s, ne, se, sw]
                     s.x > seat.x && s.y < seat.y && ne == nil -> [nw, s, se, sw]
                     s.x > seat.x && s.y > seat.y && se == nil -> [nw, ne, s, sw]
                     s.x < seat.x && s.y > seat.y && sw == nil -> [nw, ne, se, s]
                     true -> [nw, ne, se, sw]
                   end
                   {(if Enum.any?(updated, &(&1 == nil)), do: :cont, else: :halt), updated}
                 end
               )
            |> (fn diagonals -> mapper.(diagonals ++ horizontal ++ vertical) end).()
          end
        )
      end
    )
  end

  def part2(list), do: process(list, &part_two_neighbors/1, 5)
end