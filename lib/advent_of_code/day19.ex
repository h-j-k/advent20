defmodule AdventOfCode.Day19 do
  @moduledoc "Day 19"

  @is_char ~r/^"(.)"$/

  defp get(rules, indices) when is_list(indices), do: Enum.reduce(
    Enum.map(indices, &(get(rules, &1))),
    fn x, acc -> Enum.flat_map(acc, fn v -> Enum.map(x, &(v <> &1)) end) end
  )

  defp get(rules, index) when is_integer(index), do:
    MapSet.new(Enum.flat_map(rules[index], &(if is_binary(&1), do: [&1], else: get(rules, &1))))

  defp convert(x, delimiter, mapper), do: Enum.map(String.split(x, delimiter), mapper)

  defp parse(rules), do: Map.new(
    rules,
    fn line ->
      [_, key, rule] = Regex.run(~r/^(\d+): (.*)$/, line)
      value = cond do
        Regex.match?(@is_char, rule) -> (&(tl(&1))).(Regex.run(@is_char, rule))
        true -> convert(rule, " | ", fn x -> convert(x, " ", &String.to_integer/1) end)
      end
      {String.to_integer(key), value}
    end
  )

  defp process(input) do
    rules = parse(hd(input))
    matches = get(rules, 0)
    Enum.group_by(Enum.at(input, 1), &(&1 in matches))
  end

  def part1(input), do: Enum.count(process(input)[true])

  def part2(input) do
    rules = parse(hd(input))
    by_0 = process(input)
    original = Enum.count(by_0[true])
    leftovers = by_0[false]
    0
  end
end