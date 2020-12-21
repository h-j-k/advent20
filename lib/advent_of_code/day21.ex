defmodule AdventOfCode.Day21 do
  @moduledoc "Day 21"

  defmodule Food do
    defstruct ingredients: MapSet.new(), allergens: MapSet.new()
  end

  defp parse(food) do
    to_set = &(MapSet.new(String.split(&1, &2)))
    [_, ingredients, allergens] = Regex.run(~r/^(.*) \(contains (.*)\)$/, food)
    %Food{ingredients: to_set.(ingredients, " "), allergens: to_set.(allergens, ", ")}
  end

  defp process(input) do
    all_food = Enum.map(input, &parse/1)
    by_allergen = Map.new(
      Enum.reduce(all_food, MapSet.new(), &(MapSet.union(&1.allergens, &2))),
      fn allergen ->
        case Enum.filter(all_food, &(allergen in &1.allergens)) do
          [] -> {allergen, []}
          x -> {allergen, Enum.reduce(tl(x), hd(x).ingredients, &(MapSet.intersection(&1.ingredients, &2)))}
        end
      end
    )
    {all_food, by_allergen}
  end

  def part1(input) do
    {all_food, by_allergen} = process(input)
    bad = MapSet.new(Enum.flat_map(by_allergen, &(elem(&1, 1))))
    Enum.sum(Enum.map(all_food, fn food -> Enum.count(Enum.filter(food.ingredients, &(!(&1 in bad)))) end))
  end

  def part2(input) do
    {_, by_allergen} = process(input)
    Enum.reduce(
      Enum.sort_by(by_allergen, &(Enum.count(elem(&1, 1)))),
      Map.new(),
      fn {allergen, ingredients}, acc -> Map.put(acc, hd(MapSet.to_list(ingredients) -- Map.keys(acc)), allergen) end
    )
    |> Enum.sort_by(&(elem(&1, 1)))
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.join(",")
  end
end