defmodule AdventOfCode.Day13 do
  @moduledoc "Day 13"

  defp parse(buses), do: Enum.filter(
    Enum.map(
      String.split(buses, ","),
      fn
        "x" -> nil
        bus -> String.to_integer(bus)
      end
    ),
    &(&1 != nil)
  )

  def part1(list) do
    target = String.to_integer(Enum.at(list, 0))
    bus = Enum.max_by(parse(Enum.at(list, 1)), &(rem(target, &1)))
    bus * (bus - rem(target, bus))
  end

  def part2(list) do
    -1
  end
end