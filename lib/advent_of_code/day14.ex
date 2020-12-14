defmodule AdventOfCode.Day14 do
  @moduledoc "Day 14"

  import Bitwise

  defp convert(value), do: String.graphemes(String.pad_leading(Integer.to_string(value, 2), 36, "0"))

  defp process(value, mask) do
    mapper = fn
      {_, "1"} -> "1"
      {_, "0"} -> "0"
      {v, "X"} -> v
    end
    Enum.zip(convert(value), mask)
    |> Enum.map(mapper)
    |> Enum.join
    |> (fn masked -> String.to_integer(masked, 2) end).()
  end

  def part1(program) do
    {r, _} = Enum.reduce(
      program,
      {%{}, ""},
      fn line, {mem, mask} ->
        cond do
          String.starts_with?(line, "mask =") ->
            [_, _, next] = String.split(line, " ")
            {mem, String.graphemes(next)}
          String.starts_with?(line, "mem") ->
            [_, key, value] = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, line)
            {Map.put(mem, String.to_integer(key), process(String.to_integer(value), mask)), mask}
        end
      end
    )
    Enum.reduce(r, 0, &(elem(&1, 1) + &2))
  end

  def part2(program), do: 0
end