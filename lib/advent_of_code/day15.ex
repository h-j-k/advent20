defmodule AdventOfCode.Day15 do
  @moduledoc "Day 15"

  defp example(program) do
    case program do
      "0,3,6" -> 436
      "1,3,2" -> 1
      "2,1,3" -> 10
      "1,2,3" -> 27
      "2,3,1" -> 78
      "3,2,1" -> 438
      "3,1,2" -> 1836
    end
  end

  def part1(input) do
    numbers = Enum.map(String.split(Enum.at(input, 0), ","), &String.to_integer/1)
    start = Map.new(Enum.with_index(numbers, 1), &({elem(&1, 0), [elem(&1, 1)]}))
    {_, r} = Enum.reduce(
      1..2020,
      {start, nil},
      fn turn, {mem, last} ->
        if turn <= Enum.count(numbers) do
          {Map.put(mem, Enum.at(numbers, turn - 1), [turn]), Enum.at(numbers, turn - 1)}
        else
          past = Map.get(mem, last, [])
          if Enum.count(past) <= 1 do
            {Map.put(mem, 0, [turn | Map.get(mem, 0, [])]), 0}
          else
            [a, b] = Enum.take(past, 2)
            {Map.put(mem, a - b, [turn | Map.get(mem, a - b, [])]), a - b}
          end
        end
      end
    )
    r
  end

  def part2(program), do: 0
end