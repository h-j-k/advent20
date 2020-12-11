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

  defp process(seats, grid, get_occupied, to_empty_threshold) do
    fn seat ->
      occupied = Enum.count(get_occupied.(seats, grid, seat), &(MapSet.member?(seats, &1)))
      empty? = cond do
        seat.empty? && occupied == 0 -> false
        !seat.empty? && occupied >= to_empty_threshold -> true
        true -> seat.empty?
      end
      %Seat{x: seat.x, y: seat.y, empty?: empty?}
    end
  end

  defp process(list, get_occupied, to_empty_threshold) do
    {seats, grid} = parse(list)
    process = &(MapSet.new(Enum.map(&1, process(&1, grid, get_occupied, to_empty_threshold))))
    r = Enum.at(
      Stream.unfold(
        MapSet.new(seats),
        fn current -> (&(if &1 == current, do: nil, else: {current, &1})).(process.(current)) end
      ),
      -1
    )
    Enum.count(process.(r), &(!&1.empty?))
  end

  def part1(list), do: process(
    list,
    fn _, grid, seat ->
      Enum.filter(
        Enum.map(
          [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}],
          fn {x, y} -> %Seat{x: seat.x + x, y: seat.y + y, empty?: false} end
        ),
        &(&1.x <= grid.max_x && &1.y <= grid.max_y)
      )
    end,
    4
  )

  def part2(list) do
    -1
  end
end