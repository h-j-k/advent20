defmodule AdventOfCode.Day11 do
  @moduledoc "Day 11"

  defmodule Seat, do: defstruct x: 0, y: 0, empty?: true

  defmodule SeatMap do
    defstruct by_row: %{}, neighbors: %{}

    def new(by_row, neighbors) when is_function(neighbors), do: %SeatMap{
      by_row: by_row,
      neighbors: Map.new(Enum.flat_map(by_row, &(Enum.map(elem(&1, 1), neighbors.(by_row)))))
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

  defp part_one_neighbors(_), do: fn seat ->
    {{seat.x, seat.y}, Enum.map(@immediate, fn {x, y} -> {seat.x + x, seat.y + y} end)}
  end

  defp sign(x) when x < 0, do: -1
  defp sign(x) when x == 0, do: 0
  defp sign(x) when x > 0, do: 1

  defp nearby(seats, finder), do: Enum.map(
    case Enum.find_index(seats, finder) do
      0 -> [Enum.at(seats, 1)]
      n -> Enum.filter(Enum.map([-1, 1], &(Enum.at(seats, n + &1))), &(&1 != nil))
    end,
    &({&1.x, &1.y})
  )

  defp part_two_neighbors(by_row), do: fn seat ->
    filter = &(seat.y != &1.y && (seat.x == &1.x || abs(seat.x - &1.x) == abs(seat.y - &1.y)))
    Enum.flat_map(by_row, fn {_, r} -> Enum.filter(r, filter) end)
    |> Enum.group_by(&(sign((seat.x - &1.x) * (seat.y - &1.y))))
    |> Enum.flat_map(fn {_, p} -> nearby(Enum.sort_by([seat | p], &(&1.y)), &(seat.y == &1.y)) end)
    |> (fn positions -> {{seat.x, seat.y}, positions ++ nearby(by_row[seat.y], &(seat.x == &1.x))} end).()
  end

  def part1(list), do: process(list, &part_one_neighbors/1, 4)

  def part2(list), do: process(list, &part_two_neighbors/1, 5)
end