defmodule AdventOfCode.Day08 do
  @moduledoc "Day 08"

  defp parse(line) do
    [_, instr, offset] = Regex.run(~r/^(acc|jmp|nop) \+?([0-9-]+)$/, line)
    {instr, String.to_integer(offset)}
  end

  defp process(acc, line) do
    {instr, offset} = parse(line)
    if (instr == "acc"), do: acc + offset, else: acc
  end

  def part1(list) do
    Stream.unfold(
      Enum.at(list, 0),
      fn {line, index} ->
        {instr, offset} = parse(line)
        {{line, index}, Enum.at(list, index + (if (instr == "jmp"), do: offset, else: 1))}
      end
    )
    |> Enum.reduce_while(
         {0, []},
         fn {line, index}, {acc, seen} ->
           if (Enum.member?(seen, index)),
              do: {:halt, {acc, seen}},
              else: {:cont, {process(acc, line), [index | seen]}}
         end
       )
    |> elem(0)
  end

  def part2(_list), do: -1
end