defmodule AdventOfCode.Day07 do
  @moduledoc "Day 07"

  @target String.to_atom("shiny gold")

  defp bag_and_count(value) do
    [_, count, bag] = Regex.run(~r/^(\d+) (.*) bags?$/, value)
    {String.to_atom(bag), String.to_integer(count)}
  end

  defp parse(list), do: Map.new(
    list,
    fn value ->
      [_, bag, contains] = Regex.run(~r/^(.*) bags contain (.*).$/, value)
      {
        String.to_atom(bag),
        case contains do
          "no other bags" -> %{}
          inside -> Map.new(String.split(inside, ", "), &bag_and_count/1)
        end
      }
    end
  )

  def contains?(inside, _bag, _rules) when inside == %{}, do: false

  def contains?(inside, bag, rules), do: Map.has_key?(inside, bag)
  || Enum.find_value(inside, false, &(contains?(rules[elem(&1, 0)], bag, rules)))

  def count(inside, n, _rules) when inside == %{}, do: n

  def count(inside, n, rules),
      do: Enum.reduce(inside, n, fn {bag, count}, acc -> acc + n * count(rules[bag], count, rules) end)

  def part1(list) do
    rules = parse(list)
    Enum.count(rules, fn {bag, _} -> bag != @target && contains?(rules[bag], @target, rules) end)
  end

  def part2(list) do
    rules = parse(list)
    Enum.reduce(rules[@target], 0, fn {bag, count}, acc -> acc + count(rules[bag], count, rules) end)
  end
end