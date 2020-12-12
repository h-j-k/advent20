defmodule AdventOfCode.Day11 do
  @moduledoc "Day 11"

  defmodule Seat, do: defstruct x: 0, y: 0, empty?: true

  defmodule SeatMap do
    defstruct seats: MapSet.new(), row: %{}, col: %{}

    defp group_by(seats, mapper) do
      Map.new(Enum.group_by(seats, mapper), fn {k, v} -> {k, MapSet.new(v)} end)
    end

    def new(seats), do: %SeatMap{
      seats: MapSet.new(seats),
      row: group_by(seats, &(&1.y)),
      col: group_by(seats, &(&1.x))
    }

    def diagonals(seat_map, seat, occupied) do
      seats = Enum.filter(
        seat_map.seats,
        &(abs(seat.x - &1.x) - abs(seat.y - &1.y) == 0)
      )
      {a, b, c, d} = Enum.reduce(
        seats,
        {nil, nil, nil, nil},
        fn s, {h, j, k, l} ->
          {
            (if s.x < seat.x && s.y < seat.y && (h == nil || s.x > h.x), do: s, else: h),
            (if s.x > seat.x && s.y < seat.y && (j == nil || s.x < j.x), do: s, else: j),
            (if s.x > seat.x && s.y > seat.y && (k == nil || s.x < k.x), do: s, else: k),
            (if s.x < seat.x && s.y > seat.y && (l == nil || s.x > l.x), do: s, else: l),
          }
        end
      )
      occupied + Enum.count([a, b, c, d], &(&1 != nil && !&1.empty?))
    end
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
    Enum.count(process.(r).seats, &(!&1.empty?))
  end

  def part1(list), do: process(
    list,
    fn seat_map, seat ->
      occupied = Enum.count(
        Enum.map(
          [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}],
          fn {x, y} -> %Seat{x: seat.x + x, y: seat.y + y, empty?: false} end
        ),
        &(MapSet.member?(seat_map.seats, &1))
      )
      cond do
        seat.empty? && occupied == 0 -> false
        !seat.empty? && occupied >= 4 -> true
        true -> seat.empty?
      end
    end
  )

  def part2(list), do: process(
    list,
    fn seat_map, seat ->
      {w, e} = Enum.reduce(
        seat_map.row[seat.y],
        {nil, nil},
        fn s, {min, max} ->
          {
            (if s.x < seat.x && (min == nil || s.x > min.x), do: s, else: min),
            (if s.x > seat.x && (max == nil || s.x < max.x), do: s, else: max),
          }
        end
      )
      if seat.empty? && Enum.any?([w, e], &(&1 != nil && !&1.empty?)) do
        seat.empty?
      else
        {n, s} = Enum.reduce(
          seat_map.col[seat.x],
          {nil, nil},
          fn s, {min, max} ->
            {
              (if s.y < seat.y && (min == nil || s.y > min.y), do: s, else: min),
              (if s.y > seat.y && (max == nil || s.y < max.y), do: s, else: max),
            }
          end
        )
        occupied = Enum.count([w, e, n, s], &(&1 != nil && !&1.empty?))
        if (!seat.empty? && occupied == 0) || (seat.empty? && occupied > 0) do
          seat.empty?
        else
          occupied = SeatMap.diagonals(seat_map, seat, occupied)
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