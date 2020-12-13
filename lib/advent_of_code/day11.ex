defmodule AdventOfCode.Day11 do
  @moduledoc "Day 11"

  defmodule Seat, do: defstruct x: 0, y: 0, empty?: true

  defmodule SeatMap do
    defstruct seats: MapSet.new(), row: %{}, col: %{}, same: MapSet.new(), to_process: MapSet.new()

    def new(seats, previous \\ MapSet.new()), do: %SeatMap{
      seats: seats,
      row: Map.new(Enum.group_by(seats, &(&1.y)), fn {k, v} -> {k, Enum.sort_by(v, &(&1.x))} end),
      col: Map.new(Enum.group_by(seats, &(&1.x)), fn {k, v} -> {k, Enum.sort_by(v, &(&1.y))} end),
      same: MapSet.intersection(seats, previous),
      to_process: MapSet.difference(seats, previous)
    }
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

  defp run(seat_map, is_empty), do: fn seat ->
    %Seat{x: seat.x, y: seat.y, empty?: is_empty.(seat_map, seat)}
  end

  defp process(list, is_empty) do
    process = &(SeatMap.new(MapSet.union(&1.same, MapSet.new(&1.to_process, run(&1, is_empty))), &1.seats))
    # process = &(SeatMap.new(MapSet.new(&1.seats, run(&1, is_empty))))
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
    neighbors = fn line, finder ->
      case Enum.find_index(line, finder) do
        0 -> [Enum.at(line, 1)]
        n -> Enum.map([-1, 1], &(Enum.at(line, n + &1)))
      end
    end
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
        horizontal = neighbors.(seat_map.row[seat.y], &(&1.x == seat.x))
        if seat.empty? && occupied(horizontal) > 0 do
          seat.empty?
        else
          occupied = occupied(horizontal ++ neighbors.(seat_map.col[seat.x], &(&1.y == seat.y)))
          if (seat.empty? && occupied > 0) || (!seat.empty? && occupied == 0) do
            seat.empty?
          else
            case occupied + diagonals.(seat_map, seat) do
              0 when seat.empty? -> false
              n when n >= 5 and not seat.empty? -> true
              _ -> seat.empty?
            end
          end
        end
      end
    )
  end
end