defmodule AdventOfCode.Day08 do
  @moduledoc "Day 08"

  defp parse(line, target, default) do
    [_, instr, offset] = Regex.run(~r/^(acc|jmp|nop) \+?([0-9-]+)$/, line)
    if instr == target, do: String.to_integer(offset), else: default
  end

  defp generate(list) do
    process = fn acc, line -> acc + parse(line, "acc", 0) end
    Enum.at(list, 0)
    |> Stream.unfold(fn {line, index} -> {{line, index}, Enum.at(list, index + parse(line, "jmp", 1))} end)
    |> Enum.reduce_while(
         {0, []},
         fn {line, index}, {acc, seen} ->
           if (Enum.member?(seen, index)),
              do: {:halt, {acc, seen}},
              else: {:cont, {process.(acc, line), [index | seen]}}
         end
       )
  end

  def part1(list), do: elem(generate(list), 0)

  def part2(_list), do: -1
end