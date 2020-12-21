defmodule AdventOfCode.Day21 do
  @moduledoc "Day 21"

  defmodule Food do
    defstruct ingredients: MapSet.new(), allergens: MapSet.new()
  end

  defp parse(food) do
    [_, ingredients, allergens] = Regex.run(~r/^(.*) \(contains (.*)\)$/, food)
    %Food{
      ingredients: MapSet.new(String.split(ingredients, " ")),
      allergens: MapSet.new(String.split(allergens, ", "))
    }
  end

  def part1(input) do
    all_food = Enum.map(input, &parse/1)
    all_allergens = Enum.reduce(all_food, MapSet.new(), &(MapSet.union(&1.allergens, &2)))
    by_allergen = Map.new(
      all_allergens,
      fn allergen ->
        case Enum.filter(all_food, &(allergen in &1.allergens)) do
          [] -> {allergen, []}
          x -> {allergen, Enum.reduce(tl(x), hd(x).ingredients, &(MapSet.intersection(&1.ingredients, &2)))}
        end
      end
    )
    bad_ingredients = MapSet.new(Enum.flat_map(by_allergen, &(elem(&1, 1))))
    IO.puts(inspect(by_allergen))
    Enum.sum(
      Enum.map(all_food, fn food -> Enum.count(Enum.filter(food.ingredients, &(!(&1 in bad_ingredients)))) end)
    )
  end

  def part2(input), do: 0
end