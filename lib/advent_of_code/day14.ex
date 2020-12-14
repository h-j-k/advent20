defmodule AdventOfCode.Day14 do
  @moduledoc "Day 14"

  defp convert(value), do: String.graphemes(String.pad_leading(Integer.to_string(value, 2), 36, "0"))

  defp part_one_process(key, value, mask) do
    mapper = fn
      {_, "1"} -> "1"
      {_, "0"} -> "0"
      {v, "X"} -> v
    end
    Enum.zip(convert(value), mask)
    |> Enum.map(mapper)
    |> Enum.join
    |> (&(%{key => String.to_integer(&1, 2)})).()
  end

  def part_two_process(key, value, mask) do
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
    |> Map.new(&({&1, value}))
  end

  defp process(program, processor) do
    {r, _} = Enum.reduce(
      program,
      {%{}, ""},
      fn line, {mem, mask} ->
        inputs = Regex.named_captures(~r/^(mask = (?<mask>.*)|mem\[(?<k>\d+)\] = (?<v>\d+))$/, line)
        case inputs["mask"] do
          "" ->
            {Map.merge(mem, processor.(String.to_integer(inputs["k"]), String.to_integer(inputs["v"]), mask)), mask}
          mask ->
            {mem, String.graphemes(mask)}
        end
      end
    )
    Enum.reduce(r, 0, &(elem(&1, 1) + &2))
  end

  def part1(program), do: process(program, &part_one_process/3)

  def part2(program), do: process(program, &part_two_process/3)
end