defmodule AdventOfCode do
  @moduledoc """
  For Advent of Code 2020
  """

  def count_chars(string), do: Enum.frequencies(String.graphemes(string))

  def from(list, target, mapper), do: Map.new(
    list,
    fn {line, index} ->
      Enum.with_index(String.graphemes(line))
      |> Enum.flat_map(fn {cell, col} -> if cell == target, do: [mapper.(col, index)], else: [] end)
      |> (&({index, &1})).()
    end
  )

  def expand(), do: fn point ->
    list = Tuple.to_list(point)
    1..length(list)
    |> Enum.reduce(
         &([List.to_tuple(Enum.map(Enum.zip(list, &1), fn {p, d} -> p + d end))]),
         fn _, mapper -> &(Enum.flat_map(-1..1, fn d -> mapper.([d | &1]) end)) end
       )
    |> (&({point, &1.([]) -- [point]})).()
  end
end
