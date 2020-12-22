defmodule AdventOfCode.Day22 do
  @moduledoc "Day 22"

  defp score(cards), do:
    Enum.reduce(Enum.with_index(Enum.reverse(cards), 1), 0, fn {x, i}, acc -> x * i + acc end)

  defp part_one_round(p1, p2) when p1 == [] when p2 == [], do: score(p1 ++ p2)
  defp part_one_round(p1, p2) when hd(p1) > hd(p2), do: part_one_round(Enum.concat(tl(p1), [hd(p1), hd(p2)]), tl(p2))
  defp part_one_round(p1, p2) when hd(p1) < hd(p2), do: part_one_round(tl(p1), Enum.concat(tl(p2), [hd(p2), hd(p1)]))

  def part1(input), do: part_one_round(
    Enum.map(tl(Enum.at(input, 0)), &String.to_integer/1),
    Enum.map(tl(Enum.at(input, 1)), &String.to_integer/1)
  )

  defp part_two_sub(p1, _, _, _) when p1 == [], do: 2
  defp part_two_sub(_, p2, _, _) when p2 == [], do: 1

  defp part_two_sub(p1, p2, p1_past, p2_past) do
    if p1 in MapSet.new(p1_past) || p2 in MapSet.new(p2_past) do
      1
    else
      if hd(p1) <= length(tl(p1)) && hd(p2) <= length(tl(p2)) do
        case part_two_sub(Enum.take(tl(p1), hd(p1)), Enum.take(tl(p2), hd(p2)), [], []) do
          1 -> part_two_sub(Enum.concat(tl(p1), [hd(p1), hd(p2)]), tl(p2), [p1 | p1_past], [p2 | p2_past])
          2 -> part_two_sub(tl(p1), Enum.concat(tl(p2), [hd(p2), hd(p1)]), [p1 | p1_past], [p2 | p2_past])
        end
      else
        cond do
          hd(p1) > hd(p2) ->
            part_two_sub(Enum.concat(tl(p1), [hd(p1), hd(p2)]), tl(p2), [p1 | p1_past], [p2 | p2_past])
          hd(p1) < hd(p2) ->
            part_two_sub(tl(p1), Enum.concat(tl(p2), [hd(p2), hd(p1)]), [p1 | p1_past], [p2 | p2_past])
        end
      end
    end
  end

  def part_two_round(p1, p2, p1_past \\ [], p2_past \\ []) do
    if p1 in MapSet.new(p1_past) || p2 in MapSet.new(p2_past) do
      score(p1)
    else
      if p1 == [] || p2 == [] do
        score(p1 ++ p2)
      else
        if hd(p1) <= length(tl(p1)) && hd(p2) <= length(tl(p2)) do
          case part_two_sub(Enum.take(tl(p1), hd(p1)), Enum.take(tl(p2), hd(p2)), [], []) do
            1 -> part_two_round(Enum.concat(tl(p1), [hd(p1), hd(p2)]), tl(p2), [p1 | p1_past], [p2 | p2_past])
            2 -> part_two_round(tl(p1), Enum.concat(tl(p2), [hd(p2), hd(p1)]), [p1 | p1_past], [p2 | p2_past])
          end
        else
          cond do
            hd(p1) > hd(p2) ->
              part_two_round(Enum.concat(tl(p1), [hd(p1), hd(p2)]), tl(p2), [p1 | p1_past], [p2 | p2_past])
            hd(p1) < hd(p2) ->
              part_two_round(tl(p1), Enum.concat(tl(p2), [hd(p2), hd(p1)]), [p1 | p1_past], [p2 | p2_past])
          end
        end
      end
    end
  end

  def part2(input), do: part_two_round(
    Enum.map(tl(Enum.at(input, 0)), &String.to_integer/1),
    Enum.map(tl(Enum.at(input, 1)), &String.to_integer/1)
  )
end