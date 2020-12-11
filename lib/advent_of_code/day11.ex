defmodule AdventOfCode.Day11 do
  @moduledoc "Day 11"

  defmodule Grid, do: defstruct max_x: 0, max_y: 0

  defmodule Seat, do: defstruct x: 0, y: 0, empty?: true

  defp seat(row), do: fn {cell, column} -> if cell == "L", do: %Seat{x: column, y: row}, else: nil end

  defp parse(list) do
    seats = Enum.flat_map(
      list,
      fn {line, index} -> Enum.filter(Enum.map(Enum.with_index(String.graphemes(line)), seat(index)), &(&1 != nil)) end
    )
    {seats, %Grid{max_x: Enum.count(String.graphemes(elem(hd(list), 0))) - 1, max_y: Enum.count(list) - 1}}
  end

  defp occupied_neighbors(grid, seat), do: Enum.filter(
    Enum.map(
      [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}],
      fn {x, y} -> %Seat{x: seat.x + x, y: seat.y + y, empty?: false} end
    ),
    &(&1.x <= grid.max_x && &1.y <= grid.max_y)
  )

  defp process(seats, grid) do
    fn seat ->
      occupied = Enum.count(occupied_neighbors(grid, seat), &(MapSet.member?(seats, &1)))
      empty? = cond do
        seat.empty? && occupied == 0 -> false
        !seat.empty? && occupied >= 4 -> true
        true -> seat.empty?
      end
      %Seat{x: seat.x, y: seat.y, empty?: empty?}
    end
  end

  def part1(list) do
    {seats, grid} = parse(list)
    r = Enum.at(
      Stream.unfold(
        MapSet.new(seats),
        fn current ->
          next = MapSet.new(Enum.map(current, process(current, grid)))
          if (next == current), do: nil, else: {current, next}
        end
      ),
      -1
    )
    Enum.count(Enum.map(r, process(r, grid)), &(!&1.empty?))
  end

  def part2(list) do
    -1
  end
end