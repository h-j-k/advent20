defmodule AdventOfCode.Day22 do
  @moduledoc "Day 22"

  defp score(cards), do:
    Enum.reduce(Enum.with_index(Enum.reverse(cards), 1), 0, fn {x, i}, acc -> x * i + acc end)

  defp parse(input), do:
    Enum.map([0, 1], fn p -> Enum.map(tl(Enum.at(input, p)), &String.to_integer/1) end)

  defp part_one_round(p1, p2) when p1 == [] when p2 == [], do: score(p1 ++ p2)
  defp part_one_round([h1 | t1], [h2 | t2]) when h1 > h2, do: part_one_round(t1 ++ [h1, h2], t2)
  defp part_one_round([h1 | t1], [h2 | t2]) when h1 < h2, do: part_one_round(t1, t2 ++ [h2, h1])

  def part1(input), do: (fn [p1, p2] -> part_one_round(p1, p2) end).(parse(input))

  defp part_two_round([h1 | t1], [h2 | t2], p1_past, p2_past, repeat, next) do
    if [h1 | t1] in MapSet.new(p1_past) || [h2 | t2] in MapSet.new(p2_past) do
      repeat.([h1 | t1])
    else
      winner = if h1 <= length(t1) && h2 <= length(t2),
                  do: part_two_sub(Enum.take(t1, h1), Enum.take(t2, h2), [], []),
                  else: (if h1 > h2, do: 1, else: 2)
      case winner do
        1 -> next.(t1 ++ [h1, h2], t2, [[h1 | t1] | p1_past], [[h2 | t2] | p2_past])
        2 -> next.(t1, t2 ++ [h2, h1], [[h1 | t1] | p1_past], [[h2 | t2] | p2_past])
      end
    end
  end

  defp part_two_sub(p1, p2, _, _) when p1 == [] when p2 == [], do:
    Enum.find_index([nil, p2, p1], &(&1 == []))

  defp part_two_sub(p1, p2, p1_past, p2_past), do:
    part_two_round(p1, p2, p1_past, p2_past, fn _ -> 1 end, &part_two_sub/4)

  defp part_two_round(p1, p2, _, _) when p1 == [] when p2 == [], do: score(p1 ++ p2)

  defp part_two_round(p1, p2, p1_past, p2_past), do:
    part_two_round(p1, p2, p1_past, p2_past, &score/1, &part_two_round/4)

  def part2(input), do: (fn [p1, p2] -> part_two_round(p1, p2, [], []) end).(parse(input))
end