defmodule AdventOfCode.Day05 do
  @moduledoc "Day 05"

  @mapping %{"F" => true, "B" => false, "L" => true, "R" => false}

  defp partition(is_lower, {min, max}) do
    (&(if is_lower, do: {min, &1}, else: {&1, max})).(min + div(1 + max - min, 2))
  end

  defp process(range, sequence), do: String.graphemes(sequence)
                                     |> Enum.map(&(@mapping[&1]))
                                     |> Enum.reduce(range, &partition/2)
                                     |> elem(0)

  defp process(list), do: Enum.map(
    list,
    fn value ->
      [_, row, column] = Regex.run(~r/([FB]{7})([LR]{3})/, value)
      (&(&1 * 8 + &2)).(process({0, 127}, row), process({0, 7}, column))
    end
  )

  def part1(list), do: Enum.max(process(list))

  def part2(list) do
    [sum, {min, max}] = (&([Enum.sum(&1), Enum.min_max(&1)])).(process(list))
    div((1 + max - min) * (min + max), 2) - sum
  end
end