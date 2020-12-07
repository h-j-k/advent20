defmodule AdventOfCode.Day07 do
  @moduledoc "Day 07"

  defmodule Bag, do: defstruct color: :a_color

  defmodule BagContent, do: defstruct bag: Bag, contains: %{}

  defp bag_and_count(value) do
    [_, count, color] = Regex.run(~r/^(\d+) (.*) bags?$/, value)
    {%Bag{color: String.to_atom(color)}, String.to_integer(count)}
  end

  defp parse(value) do
    [_, color, contains] = Regex.run(~r/^(.*) bags contain (.*).$/, value)
    %BagContent{
      bag: %Bag{
        color: String.to_atom(color)
      },
      contains: case contains do
        "no other bags" -> %{}
        others -> Map.new(String.split(others, ", "), &bag_and_count/1)
      end
    }
  end

  defp parse_rules(list), do: Map.new(Enum.map(list, &parse/1), &({&1.bag, &1.contains}))

  def contains?(children, _target, _rules) when children == %{}, do: false

  def contains?(children, target, rules), do: Map.has_key?(children, target) || Enum.find_value(
    children,
    false,
    fn {bag, _} -> contains?(Map.get(rules, bag), target, rules) end
  )

  def count(children, acc, _rules) when children == %{}, do: acc

  def count(children, acc, rules),
      do: children
          |> Enum.map(fn {bag, count} -> acc * count(Map.get(rules, bag), count, rules) end)
          |> (&(Enum.sum(&1) + acc)).()

  def part1(list) do
    rules = parse_rules(list)
    target = %Bag{color: String.to_atom("shiny gold")}
    Enum.count(
      rules,
      fn {bag, _} -> bag != target && contains?(Map.get(rules, bag), target, rules) end
    )
  end

  def part2(list) do
    rules = parse_rules(list)
    target = %Bag{color: String.to_atom("shiny gold")}
    Enum.reduce(
      Map.get(rules, target),
      0,
      fn {bag, count}, acc -> acc + count(Map.get(rules, bag), count, rules) end
    )
  end
end