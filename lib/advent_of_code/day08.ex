defmodule AdventOfCode.Day08 do
  @moduledoc "Day 08"

  defp parse(line) do
    [_, instr, offset] = Regex.run(~r/^(acc|jmp|nop) \+?([0-9-]+)$/, line)
    %{String.to_atom(instr) => String.to_integer(offset)}
  end

  defp generate(list), do: Enum.reduce_while(
    Stream.unfold(
      Enum.at(list, 0),
      fn {line, index} ->
        next = &(Enum.at(list, &1, {line, &1}))
        if index == length(list), do: nil, else: {{line, index}, next.(index + Map.get(parse(line), :jmp, 1))}
      end
    ),
    {0, []},
    fn {line, index}, {acc, seen} ->
      {go, inc} = if Enum.member?(seen, index), do: {:halt, 0}, else: {:cont, Map.get(parse(line), :acc, 0)}
      {go, {acc + inc, [index | seen]}}
    end
  )

  def part1(list), do: elem(generate(list), 0)

  def part2(list) do
    {_, [head | rest]} = generate(list)
    Enum.reduce_while(
      rest,
      head,
      fn index, _ ->
        test = fn line ->
          {acc, [last | _]} = generate(List.replace_at(list, index, {line, index}))
          if last + 1 == length(list), do: {:halt, acc}, else: {:cont, index}
        end
        case parse(elem(Enum.at(list, index), 0)) do
          %{:acc => _} -> {:cont, index}
          %{:jmp => offset} -> test.("nop #{offset}")
          %{:nop => offset} -> test.("jmp #{offset}")
        end
      end
    )
  end
end