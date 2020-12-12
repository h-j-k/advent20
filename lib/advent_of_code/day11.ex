defmodule AdventOfCode.Day11 do
  @moduledoc "Day 11"

  defmodule Seat do
    defstruct x: 0, y: 0, empty?: true
  end

  defmodule SeatMap do
    defstruct seats: MapSet.new(), row: %{}, col: %{}

    def new(seats), do: %SeatMap{
      seats: MapSet.new(seats),
      row: Map.new(Enum.group_by(seats, &(&1.y)), fn {k, v} -> {k, Enum.sort_by(v, &(&1.x))} end),
      col: Map.new(Enum.group_by(seats, &(&1.x)), fn {k, v} -> {k, Enum.sort_by(v, &(&1.y))} end)
    }
  end

  defp seat(row), do: fn {cell, col} ->
    if cell == "L", do: %Seat{x: col, y: row}, else: nil
  end

  defp parse(list), do: Enum.flat_map(
    list,
    fn {line, index} ->
      String.graphemes(line)
      |> Enum.with_index
      |> Enum.map(seat(index))
      |> Enum.filter(&(&1 != nil))
    end
  )

  defp occupied(seats), do: Enum.count(seats, &(&1 != nil && !&1.empty?))

  defp run(seat_map, is_empty), do: fn seat ->
    %Seat{x: seat.x, y: seat.y, empty?: is_empty.(seat_map, seat)}
  end

  defp process(list, is_empty) do
    process = &(SeatMap.new(MapSet.new(&1.seats, run(&1, is_empty))))
    r = Enum.at(
      Stream.unfold(
        SeatMap.new(parse(list)),
        fn current ->
          next = process.(current)
          if next == current, do: nil, else: {current, next}
        end
      ),
      -1
    )
    occupied(process.(r).seats)
  end

  def part1(list), do: process(
    list,
    fn seat_map, seat ->
      occupied = Enum.reduce_while(
        Enum.map(
          [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}],
          fn {x, y} -> %Seat{x: seat.x + x, y: seat.y + y, empty?: false} end
        ),
        0,
        fn s, acc ->
          if MapSet.member?(seat_map.seats, s) do
            if seat.empty? || acc == 3, do: {:halt, 4}, else: {:cont, acc + 1}
          else
            {:cont, acc}
          end
        end
      )
      if (seat.empty? && occupied == 0) || (!seat.empty? && occupied >= 4),
         do: !seat.empty?, else: seat.empty?
    end
  )

  def part2(list) do
    diagonals = fn seat_map, seat ->
      Enum.filter(seat_map.seats, &(abs(seat.x - &1.x) - abs(seat.y - &1.y) == 0))
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
      |> occupied
    end
    process(
      list,
      fn seat_map, seat ->
        row = seat_map.row[seat.y]
        x_index = Enum.find_index(row, &(&1.x == seat.x))
        x_offset = if x_index == 0, do: [1], else: [-1, 1]
        horizontal = Enum.map(x_offset, &(Enum.at(row, x_index + &1)))
        if seat.empty? && occupied(horizontal) > 0 do
          seat.empty?
        else
          col = seat_map.col[seat.x]
          y_index = Enum.find_index(col, &(&1.y == seat.y))
          y_offset = if y_index == 0, do: [1], else: [-1, 1]
          occupied = occupied(horizontal ++ Enum.map(y_offset, &(Enum.at(col, y_index + &1))))
          if (seat.empty? && occupied > 0) || (!seat.empty? && occupied == 0) do
            seat.empty?
          else
            occupied = occupied + diagonals.(seat_map, seat)
            cond do
              seat.empty? && occupied == 0 -> false
              !seat.empty? && occupied >= 5 -> true
              true -> seat.empty?
            end
          end
        end
      end
    )
  end
end