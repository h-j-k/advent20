defmodule AdventOfCode.Day16 do
  @moduledoc "Day 16"

  defp parse_rules(rules), do: Map.new(
    rules,
    fn rule ->
      map = fn x1, x2 -> String.to_integer(x1)..String.to_integer(x2) end
      [_, key, a1, a2, b1, b2] = Regex.run(~r/^(.*): (\d+)-(\d+) or (\d+)-(\d+)$/, rule)
      {key, fn x -> x in map.(a1, a2) || x in map.(b1, b2) end}
    end
  )

  defp parse(input) do
    map = fn group -> Enum.map(tl(group), fn t -> Enum.map(String.split(t, ","), &String.to_integer/1) end) end
    [rules, own, nearby] = input
    {parse_rules(rules), hd(map.(own)), map.(nearby)}
  end

  defp process(input) do
    {rules, own, nearby} = parse(input)
    Enum.reduce(
      nearby,
      {nil, nil, []},
      fn ticket, {_, _, tickets} ->
        invalid = Enum.reject(ticket, &(Enum.any?(rules, fn {_, valid?} -> valid?.(&1) end)))
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
    |> Enum.reduce(&(Map.merge(&1, &2, fn _, v1, v2 -> v1 ++ v2 end)))
    |> Enum.map(
         fn {col, values} ->
           {col, Enum.map(Enum.filter(rules, fn {_, valid?} -> Enum.all?(values, valid?) end), &(elem(&1, 0)))}
         end
       )
    |> Enum.sort_by(&(length(elem(&1, 1))))
    |> Enum.reduce(Map.new(), fn {col, matches}, acc -> Map.put(acc, hd(matches -- Map.keys(acc)), col) end)
    |> Enum.filter(fn {key, _} -> String.starts_with?(key, "departure") end)
    |> Enum.reduce(1, fn {_, col}, acc -> Enum.at(own, col) * acc end)
  end
end