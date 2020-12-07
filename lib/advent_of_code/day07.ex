defmodule AdventOfCode.Day07 do
  @moduledoc "Day 07"

  @target String.to_atom("shiny gold")

  defp bag_and_count(value) do
    [_, count, bag] = Regex.run(~r/^(\d+) (.*) bags?$/, value)
    {String.to_atom(bag), String.to_integer(count)}
  end

  defp parse(value) do
    [_, bag, contains] = Regex.run(~r/^(.*) bags contain (.*).$/, value)
    {
      String.to_atom(bag),
      case contains do
        "no other bags" -> %{}
        others -> Map.new(String.split(others, ", "), &bag_and_count/1)
      end
    }
  end

  defp parse_rules(list), do: Map.new(Enum.map(list, &parse/1))

  def contains?(inside, _target, _rules) when inside == %{}, do: false

  def contains?(inside, target, rules), do: Map.has_key?(inside, target) || Enum.find_value(
    inside,
    false,
    fn {bag, _} -> contains?(Map.get(rules, bag), target, rules) end
  )

  def count(inside, acc, _rules) when inside == %{}, do: acc

  def count(inside, acc, rules),
      do: Enum.map(inside, fn {bag, count} -> acc * count(Map.get(rules, bag), count, rules) end)
          |> (&(Enum.sum(&1) + acc)).()

  def part1(list),
      do: (
        &(Enum.count(&1, fn {bag, _} -> bag != @target && contains?(Map.get(&1, bag), @target, &1) end))
        ).(parse_rules(list))

  def part2(list),
      do: (
        &(Enum.reduce(Map.get(&1, @target), 0, fn {bag, count}, acc -> acc + count(Map.get(&1, bag), count, &1) end))
        ).(parse_rules(list))
end