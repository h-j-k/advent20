defmodule AdventOfCode.Day16 do
  @moduledoc "Day 16"

  defp parse_rules(rules), do: Map.new(
    rules,
    fn rule ->
      convert = fn x1, x2 -> String.to_integer(x1)..String.to_integer(x2) end
      [_, key, a1, a2, b1, b2] = Regex.run(~r/^(.*): (\d+)-(\d+) or (\d+)-(\d+)$/, rule)
      {key, fn x -> x in convert.(a1, a2) || x in convert.(b1, b2) end}
    end
  )

  defp convert(group), do:
    Enum.map(Enum.drop(group, 1), fn line -> Enum.map(String.split(line, ","), &String.to_integer/1) end)

  defp parse(input) do
    [rules, own, nearby] = input
    [parse_rules(rules), convert(own), convert(nearby)]
  end

  def part1(input) do
    [rules, _, nearby] = parse(input)
    nearby
    |> Enum.flat_map(fn ticket -> Enum.reject(ticket, &(Enum.any?(rules, fn {_, checker} -> checker.(&1) end))) end)
    |> Enum.sum
  end

  def part2(_input), do: 0
end