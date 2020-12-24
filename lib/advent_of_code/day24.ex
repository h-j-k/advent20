defmodule AdventOfCode.Day24 do
  @moduledoc "Day 24"

  defp parse(line), do:
    Enum.map(Regex.scan(~r/([ns]?[ew])/, line), fn [x, _] -> String.to_atom(x) end)

  defp offset(:e, {x, y, z}), do: {x + 1, y - 1, z}
  defp offset(:w, {x, y, z}), do: {x - 1, y + 1, z}
  defp offset(:nw, {x, y, z}), do: {x, y + 1, z - 1}
  defp offset(:ne, {x, y, z}), do: {x + 1, y, z - 1}
  defp offset(:sw, {x, y, z}), do: {x - 1, y, z + 1}
  defp offset(:se, {x, y, z}), do: {x, y - 1, z + 1}

  defp shift(moves), do: Enum.reduce(moves, {0, 0, 0}, &offset/2)

  def part1(input), do: Enum.count(
    Enum.reduce(input, %{}, fn line, map -> Map.update(map, shift(parse(line)), true, &(!&1)) end),
    fn {_, black?} -> black? end
  )

  def part2(input) do
    0
  end
end