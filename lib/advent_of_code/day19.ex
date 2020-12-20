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

  defp convert(x, splitter, mapper), do: Enum.map(String.split(x, splitter), mapper)

  defp parse(rules), do: Map.new(
    rules,
    fn line ->
      [_, k, v] = Regex.run(~r/^(\d+): (.*)$/, line)
      ab = ~r/^"([ab])"$/
      rule = cond do
        Regex.match?(ab, v) -> (&(tl(&1))).(Regex.run(ab, v))
        true -> convert(v, " | ", fn x -> convert(x, " ", &String.to_integer/1) end)
      end
      {String.to_integer(k), rule}
    end
  )

  #  Given groups of 8 characters and rule 0: 8 11
  #  Part 1: 2 groups of 42 and 1 group of 31:
  #  8: 42
  #  11: 42 31
  #  Part 2: at least 2 groups of 42 and 1 group of 31:
  #  8: 42 | 42 8
  #  11: 42 31 | 42 11 31
  defp process(input, validator) do
    rules = (fn r -> Map.new([42, 31], &({&1, get(r, &1)})) end).(parse(hd(input)))
    mapper = fn group -> Enum.find_value(rules, fn {r, x} -> if group in x, do: r, else: nil end) end
    Enum.count(Enum.at(input, 1), &(validator.(Enum.map((for <<x :: binary - 8 <- &1>>, do: x), mapper))))
  end

  def part1(input), do: process(input, &(&1 == [42, 42, 31]))

  def part2(input), do:
    process(input, &(Enum.dedup(&1) == [42, 31] && (fn r -> r[42] - r[31] >= 1 end).(Enum.frequencies(&1))))
end