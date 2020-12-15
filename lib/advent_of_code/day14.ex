defmodule AdventOfCode.Day14 do
  @moduledoc "Day 14"

  defp convert(value), do: String.graphemes(String.pad_leading(Integer.to_string(value, 2), 36, "0"))

  defp process(program, processor), do: Enum.reduce(
    Enum.reduce(
      program,
      %{mask: ""},
      fn line, mem ->
        case Regex.named_captures(~r/^(mask = (?<mask>.*)|mem\[(?<k>\d+)\] = (?<v>\d+))$/, line) do
          %{"mask" => "", "k" => k, "v" => v} ->
            Map.merge(mem, processor.(String.to_integer(k), String.to_integer(v), mem.mask))
          %{"mask" => mask, "k" => _, "v" => _} ->
            %{mem | mask: String.graphemes(mask)}
        end
      end
    ),
    0,
    fn {_, v}, acc -> if is_integer(v), do: acc + v, else: acc end
  )

  def part1(program), do: process(
    program,
    fn key, value, mask ->
      mapper = fn
        {_, "1"} -> "1"
        {_, "0"} -> "0"
        {v, "X"} -> v
      end
      Enum.map(Enum.zip(convert(value), mask), mapper)
      |> (fn masked -> [Enum.join(masked)] end).()
      |> Map.new(&({key, String.to_integer(&1, 2)}))
    end
  )

  def part2(program), do: process(
    program,
    fn key, value, mask ->
      mapper = fn
        {_, "1"} -> ["1"]
        {v, "0"} -> [v]
        {_, "X"} -> ["0", "1"]
      end
      Enum.map(Enum.zip(convert(key), mask), mapper)
      |> Enum.reduce(fn x, acc -> Enum.flat_map(acc, fn v -> Enum.map(x, &(v <> &1)) end) end)
      |> Map.new(&({String.to_integer(&1, 2), value}))
    end
  )
end