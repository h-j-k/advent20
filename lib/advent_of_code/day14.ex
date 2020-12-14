defmodule AdventOfCode.Day14 do
  @moduledoc "Day 14"

  defp convert(value), do: String.graphemes(String.pad_leading(Integer.to_string(value, 2), 36, "0"))

  defp part_one_process(value, mask) do
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
            {Map.put(mem, String.to_integer(key), part_one_process(String.to_integer(value), mask)), mask}
        end
      end
    )
    Enum.reduce(r, 0, &(elem(&1, 1) + &2))
  end

  def part_two_process(key, mask) do
    mapper = fn
      {_, "1"} -> ["1"]
      {v, "0"} -> [v]
      {_, "X"} -> ["0", "1"]
    end
    Enum.zip(convert(key), mask)
    |> Enum.map(mapper)
    |> Enum.reverse
    |> Enum.reduce(fn x, acc -> Enum.flat_map(acc, fn v -> Enum.map(x, &("#{&1}#{v}")) end) end)
    |> Enum.map(&(String.to_integer(&1, 2)))
  end

  def part2(program) do
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
            {
              Map.merge(
                mem,
                Map.new(part_two_process(String.to_integer(key), mask), &({&1, String.to_integer(value)}))
              ),
              mask
            }
        end
      end
    )
    Enum.reduce(r, 0, &(elem(&1, 1) + &2))
  end
end