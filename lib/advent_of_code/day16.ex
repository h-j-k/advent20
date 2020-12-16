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
    {parse_rules(rules), hd(convert(own)), convert(nearby)}
  end

  defp process(input) do
    {rules, own, nearby} = parse(input)
    Enum.reduce(
      nearby,
      {nil, nil, []},
      fn ticket, {_, _, tickets} ->
        invalid = Enum.reject(ticket, &(Enum.any?(rules, fn {_, checker} -> checker.(&1) end)))
        {rules, own, [{ticket, invalid} | tickets]}
      end
    )
  end

  def part1(input) do
    {_, _, nearby} = process(input)
    Enum.sum(Enum.flat_map(nearby, &(elem(&1, 1))))
  end

  def part2(input) do
    {rules, own, nearby} = process(input)
    Enum.filter(nearby, &(elem(&1, 1) == []))
    |> Enum.map(fn {ticket, _} -> Map.new(Enum.with_index(ticket), fn {n, index} -> {index, [n]} end) end)
    |> Enum.reduce(fn x, acc -> Map.merge(acc, x, fn _, v1, v2 -> v1 ++ v2 end) end)
    |> Enum.map(
         fn {col, values} ->
           matched = Enum.filter(rules, fn {_, checker} -> Enum.all?(values, &(checker.(&1))) end)
           {col, Enum.map(matched, &(elem(&1, 0)))}
         end
       )
    |> Enum.sort_by(&(length(elem(&1, 1))))
    |> Enum.reduce(
         Map.new(),
         fn {col, matches}, acc -> Map.put(acc, hd(matches -- Map.keys(acc)), col) end
       )
    |> Enum.filter(fn {key, _} -> String.starts_with?(key, "departure") end)
    |> Enum.reduce(1, fn {key, col}, acc -> Enum.at(own, col) * acc end)
  end
end