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
        next = index + parse(line, "jmp", 1)
        if index == Enum.count(list),
           do: nil,
           else: {{line, index}, Enum.at(list, next, {line, next})}
      end
    )
    |> Enum.reduce_while(
         {0, []},
         fn {line, index}, {acc, seen} ->
           if Enum.member?(seen, index),
              do: {:halt, {acc, [index | seen]}},
              else: {:cont, {acc + parse(line, "acc", 0), [index | seen]}}
         end
       )
  end

  def part1(list), do: elem(generate(list), 0)

  def part2(list) do
    last_index = Enum.count(list) - 1
    original = elem(generate(list), 1)
    change = fn current ->
      line = elem(Enum.at(list, current), 0)
      {from_instr, offset} = parse(line)
      new_instr = if from_instr == "jmp", do: "nop #{offset}", else: "jmp #{offset}"
      {acc, [head | _]} = generate(List.replace_at(list, current, {new_instr, current}))
      if head == last_index, do: {:halt, acc}, else: {:cont, current}
    end
    Enum.reduce_while(
      original,
      Enum.at(original, 0),
      fn current, _ ->
        if String.starts_with?(elem(Enum.at(list, current), 0), "acc"),
           do: {:cont, current}, else: change.(current)
      end
    )
  end
end