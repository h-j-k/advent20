defmodule AdventOfCode.Day19 do
  @moduledoc "Day 19"

  @is_char ~r/^"(.)"$/

  defp get(rules, indices) when is_list(indices), do: Enum.reduce(
    Enum.map(indices, fn index -> get(rules, index) end),
    fn x, acc -> Enum.flat_map(acc, fn v -> Enum.map(x, &(v <> &1)) end) end
  )

  defp get(rules, index) when is_integer(index), do: Enum.flat_map(
    rules[index],
    fn
      v when is_binary(v) -> [v]
      x -> get(rules, x)
    end
  )

  def part1(input) do
    convert = fn x, delimiter, mapper -> Enum.map(String.split(x, delimiter), mapper) end
    rules = Map.new(
      hd(input),
      fn line ->
        [_, key, rule] = Regex.run(~r/^(\d+): (.*)$/, line)
        value = cond do
          Regex.match?(@is_char, rule) -> (&(tl(&1))).(Regex.run(@is_char, rule))
          true -> convert.(rule, " | ", fn x -> convert.(x, " ", &String.to_integer/1) end)
        end
        {String.to_integer(key), value}
      end
    )
    matches = MapSet.new(get(rules, 0))
    Enum.count(Enum.at(input, 1), &(&1 in matches))
  end

  def part2(input), do: 0
end