defmodule AdventOfCode.Day08 do
  @moduledoc "Day 08"

  defp parse(line) do
    [_, instr, offset] = Regex.run(~r/^(acc|jmp|nop) \+?([0-9-]+)$/, line)
    {instr, String.to_integer(offset)}
  end

  defp at(line, target, default), do: (&(if elem(&1, 0) == target, do: elem(&1, 1), else: default)).(parse(line))

  defp generate(list), do: Enum.reduce_while(
    Stream.unfold(
      Enum.at(list, 0),
      fn {line, index} ->
        next = &(Enum.at(list, &1, {line, &1}))
        if index == length(list), do: nil, else: {{line, index}, next.(index + at(line, "jmp", 1))}
      end
    ),
    {0, []},
    fn {line, index}, {acc, seen} ->
      if Enum.member?(seen, index), do: {:halt, {acc, seen}}, else: {:cont, {acc + at(line, "acc", 0), [index | seen]}}
    end
  )

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
            |> (fn {acc, [last | _]} -> if last + 1 == length(list), do: {:halt, acc}, else: cont end).()
        end
      end
    )
  end
end