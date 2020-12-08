defmodule AdventOfCode.Day08 do
  @moduledoc "Day 08"

  defp parse(line) do
    [_, instr, offset] = Regex.run(~r/^(acc|jmp|nop) \+?([0-9-]+)$/, line)
    {instr, String.to_integer(offset)}
  end

  defp parse(line, target, default) do
    {instr, offset} = parse(line)
    if instr == target, do: offset, else: default
  end

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
    [head | rest] = elem(generate(list), 1)
    Enum.reduce_while(
      rest,
      head,
      fn current, _ ->
        {from_instr, offset} = parse(elem(Enum.at(list, current), 0))
        if String.starts_with?(from_instr, "acc") do
          {:cont, current}
        else
          new_instr = if from_instr == "jmp", do: "nop #{offset}", else: "jmp #{offset}"
          {acc, [head | _]} = generate(List.replace_at(list, current, {new_instr, current}))
          if head == Enum.count(list) - 1, do: {:halt, acc}, else: {:cont, current}
        end
      end
    )
  end
end