defmodule AdventOfCode.Day07 do
  @moduledoc "Day 07"

  defmodule Bag, do: defstruct color: :a_color

  defmodule BagContent, do: defstruct bag: Bag, contains: %{}

  defp bag_and_count(value) do
    [_, count, color] = Regex.run(~r/^(\d+) (.*) bags?$/, value)
    {%Bag{color: String.to_atom(color)}, count}
  end

  defp parse(value) do
    [_, color, contains] = Regex.run(~r/^(.*) bags contain (.*).$/, value)
    %BagContent{
      bag: %Bag{
        color: String.to_atom(color)
      },
      contains: case contains do
        "no other bags" -> %{}
        _ -> Map.new(String.split(contains, ", "), &bag_and_count/1)
      end
    }
  end

  def part1(list) do
    target = %Bag{color: String.to_atom("shiny gold")}
    rules = Enum.map(list, &parse/1)
    Stream.unfold(
      %{target => []},
      fn additions ->
        if additions != %{},
           do: {
             additions,
             Enum.flat_map(
               additions,
               fn {key, _} ->
                 current = [key, target]
                 rules
                 |> Enum.filter(fn rule -> Enum.any?(current, &(Map.has_key?(rule.contains, &1))) end)
                 |> Enum.map(
                      fn rule ->
                        Enum.reject(
                          Map.keys(rule.contains),
                          fn bag -> Enum.find(rules, &(&1.bag == bag)).contains == %{} end
                        )
                        |> (&({rule.bag, &1 -- current})).()
                      end
                    )
               end
             )
             |> Enum.into(Map.new)
           },
           else: nil
      end
    )
    |> Enum.reduce_while(
         [],
         fn additions, results ->
           if MapSet.subset?(MapSet.new(additions, fn {key, _} -> key end), MapSet.new(results)),
              do: {:halt, results},
              else: {
                :cont,
                Enum.flat_map(additions, &(elem(&1, 1)))
                |> Enum.filter(&(Enum.member?(results, &1)))
                |> (&(Enum.uniq(results ++ Map.keys(additions) ++ &1))).()
              }
         end
       )
    |> (&(Enum.count(&1) - 1)).()
  end

  def part2(_list), do: -1
end