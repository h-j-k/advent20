defmodule AdventOfCode.Day08 do
  @moduledoc "Day 08"

  defp parse(line) do
    [_, instr, offset] = Regex.run(~r/^(acc|jmp|nop) \+?([0-9-]+)$/, line)
    {instr, String.to_integer(offset)}
  end

  defp parse(line, target, default), do: (&(if elem(&1, 0) == target, do: elem(&1, 1), else: default)).(parse(line))

  defp generate(list) do
    Stream.unfold(
      Enum.at(list, 0),
      fn {line, index} ->
        if index == Enum.count(list),
           do: nil, else: {{line, index}, (&(Enum.at(list, &1, {line, &1}))).(index + parse(line, "jmp", 1))}
      end
    )
    |> Enum.reduce_while(
         {0, []},
         fn {line, index}, {acc, seen} ->
           if Enum.member?(seen, index),
              do: {:halt, {acc, seen}}, else: {:cont, {acc + parse(line, "acc", 0), [index | seen]}}
         end
       )
  end

  def part1(list), do: elem(generate(list), 0)

  def part2(list) do
    {_, [head | rest]} = generate(list)
    Enum.reduce_while(
      rest,
      head,
      fn index, _ ->
        cont = {:cont, index}
        case parse(elem(Enum.at(list, index), 0)) do
          {"acc", _} -> cont
          {instr, offset} ->
            (if instr == "jmp", do: "nop #{offset}", else: "jmp #{offset}")
            |> (fn update -> generate(List.replace_at(list, index, {update, index})) end).()
            |> (fn {acc, [last | _]} -> if last == Enum.count(list) - 1, do: {:halt, acc}, else: cont end).()
        end
      end
    )
  end
end