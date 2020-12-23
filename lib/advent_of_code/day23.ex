defmodule AdventOfCode.Day23 do
  @moduledoc "Day 23"

  defp parse(input), do: Enum.map(String.graphemes(input), &String.to_integer/1)

  defp part_one_round(0, cups, _) do
    {tail, head} = Enum.split_while(cups, &(&1 != 1))
    Enum.join(Enum.map(Enum.drop(head, 1) ++ tail, &Integer.to_string/1))
  end

  defp part_one_round(i, [current, a, b, c | rest], {min, max}) do
    {tail, head} = Enum.split_while(max..min, &(&1 != current - 1))
    destination = Enum.find(head ++ tail, &(!(&1 in [a, b, c])))
    {start, others} = Enum.split_while(rest, &(&1 != destination))
    part_one_round(i - 1, start ++ [destination, a, b, c] ++ Enum.drop(others, 1) ++ [current], {min, max})
  end

  def part1(input), do: part_one_round(100, parse(hd(input)), {1, 9})

  defp part_two_find(0, list, max) do
    if max in list, do: part_two_find(max - 1, list, max), else: max
  end

  defp part_two_find(target, list, max) do
    if target in list, do: part_two_find(target - 1, list, max), else: target
  end

  defp part_two_round(0, _, map, _), do: (&(&1 * map[&1])).(map[1])

  defp part_two_round(i, current, map, max) do
    first = map[current]
    last = map[map[first]]
    destination = part_two_find(current - 1, [first, map[first], last], max)
    updates = Map.new([{current, map[last]}, {last, map[destination]}, {destination, first}])
    part_two_round(i - 1, map[last], Map.merge(map, updates), max)
  end

  def part2(input) do
    max = 1000000
    list = Enum.reduce(
      Enum.concat(max..10, Enum.reverse(parse(hd(input)))),
      [],
      fn
        x, acc when acc == [] -> [{x, nil}]
        x, [{a, b} | rest] -> [{x, a}, {a, b} | rest]
      end
    )
    part_two_round(10000000, elem(hd(list), 0), Map.merge(Map.new(list), %{max => elem(hd(list), 0)}), max)
  end
end