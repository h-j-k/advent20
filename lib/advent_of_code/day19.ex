defmodule AdventOfCode.Day19 do
  @moduledoc "Day 19"

  defp get(rules, indices) when is_list(indices), do: MapSet.new(
    Enum.reduce(
      Enum.map(indices, &(get(rules, &1))),
      fn x, acc -> Enum.flat_map(acc, fn v -> Enum.map(x, &(v <> &1)) end) end
    )
  )

  defp get(rules, index) when is_integer(index), do:
    MapSet.new(Enum.flat_map(rules[index], &(if is_binary(&1), do: [&1], else: get(rules, &1))))

  defp convert(x, delimiter, mapper), do: Enum.map(String.split(x, delimiter), mapper)

  defp parse(rules), do: Map.new(
    rules,
    fn line ->
      [_, key, rule] = Regex.run(~r/^(\d+): (.*)$/, line)
      ab = ~r/^"([ab])"$/
      value = cond do
        Regex.match?(ab, rule) -> (&(tl(&1))).(Regex.run(ab, rule))
        true -> convert(rule, " | ", fn x -> convert(x, " ", &String.to_integer/1) end)
      end
      {String.to_integer(key), value}
    end
  )

  #  Given:
  #  ````
  #  0: 8 11
  #  8: 42
  #  11: 42 31
  #  ````
  #
  #  In part one, we are checking there's only 2 groups of 42 and 1 group of 31.
  #  In part two, the overrides are:
  #  ````
  #  8: 42 | 42 8
  #  11: 42 31 | 42 11 31
  #  ````
  #
  #  In other words, at least 2 groups of 42 and 1 group of 31.
  #  Also, each group has 8 characters only, and messages are in multiple of 8 characters.
  #  Logic: Chunk each message into groups, and check counts of group 42 and 31.
  defp process(input, validator) do
    rules = (fn r -> Map.new([42, 31], &({&1, get(r, &1)})) end).(parse(hd(input)))
    Enum.count(
      Enum.at(input, 1),
      fn message ->
        (for <<x :: binary - 8 <- message>>, do: x)
        |> Enum.map(&(if &1 in rules[42], do: 42, else: (if &1 in rules[31], do: 31, else: -1)))
        |> (&(validator.(&1))).()
      end
    )
  end

  def part1(input), do: process(input, &(&1 == [42, 42, 31]))

  def part2(input), do: 0
end