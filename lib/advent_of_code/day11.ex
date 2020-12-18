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

  defp update(seat_map, threshold), do: fn {row, row_seats} ->
    mapper = fn seat ->
      Enum.reduce_while(
        seat_map.neighbors[{seat.x, seat.y}],
        0,
        fn {x, y}, acc ->
          case Enum.find(Map.get(seat_map.by_row, y, []), &(&1.x == x)) do
            nil -> {:cont, acc}
            s when (not s.empty?) and (seat.empty? or acc + 1 == threshold) -> {:halt, threshold}
            s -> {:cont, acc + (if s.empty?, do: 0, else: 1)}
          end
        end
      )
      |> (&(((&1 == 0 && seat.empty?) || (&1 >= threshold && !seat.empty?)) != seat.empty?)).()
      |> (&(%Seat{x: seat.x, y: seat.y, empty?: &1})).()
    end
    {row, Enum.map(row_seats, mapper)}
  end

  defp process(list, neighbors, threshold), do:
    SeatMap.new(AdventOfCode.from(list, "L", &(%Seat{x: &1, y: &2})), neighbors)
    |> Stream.unfold(&({&1, SeatMap.new(Map.new(&1.by_row, update(&1, threshold)), &1.neighbors)}))
    |> Enum.reduce_while(nil, &(if &1 == &2, do: {:halt, &1.by_row}, else: {:cont, &1}))
    |> Enum.reduce(0, fn {_, row_seats}, acc -> acc + Enum.count(row_seats, &(!&1.empty?)) end)

  defp part_one_neighbors(_), do: fn seat -> AdventOfCode.expand().({seat.x, seat.y}) end

  defp nearby(seats, finder), do: Enum.map(
    case Enum.find_index(seats, finder) do
      0 -> [Enum.at(seats, 1)]
      n -> Enum.filter(Enum.map([-1, 1], &(Enum.at(seats, n + &1))), &(&1 != nil))
    end,
    &({&1.x, &1.y})
  )

  defp part_two_neighbors(by_row), do: fn seat ->
    filter = &(seat.y != &1.y && (seat.x == &1.x || abs(seat.x - &1.x) == abs(seat.y - &1.y)))
    key = &(if &1 == 0, do: 0, else: (if &1 < 0, do: -1, else: 1))
    Enum.flat_map(by_row, fn {_, r} -> Enum.filter(r, filter) end)
    |> Enum.group_by(&(key.((seat.x - &1.x) * (seat.y - &1.y))))
    |> Enum.flat_map(fn {_, p} -> nearby(Enum.sort_by([seat | p], &(&1.y)), &(seat.y == &1.y)) end)
    |> (fn positions -> {{seat.x, seat.y}, positions ++ nearby(by_row[seat.y], &(seat.x == &1.x))} end).()
  end

  def part1(list), do: process(list, &part_one_neighbors/1, 4)

  def part2(list), do: process(list, &part_two_neighbors/1, 5)
end