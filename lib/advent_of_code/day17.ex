defmodule AdventOfCode.Day17 do
  @moduledoc "Day 17"

  defp flattened_set(enum, mapper), do: MapSet.new(Enum.flat_map(enum, mapper))

  defp parse(input, to_cube), do: flattened_set(
    input,
    fn {line, y} ->
      Enum.flat_map(
        Enum.with_index(String.graphemes(line)),
        fn {cell, x} -> if cell == "#", do: [to_cube.(x, y)], else: [] end
      )
    end
  )

  defp nearby(space, cube), do: Enum.count(
    space,
    &(&1 != cube && Enum.all?(Enum.zip(Tuple.to_list(&1), Tuple.to_list(cube)), fn {a, b} -> abs(a - b) <= 1 end))
  )

  defp expand(), do: fn point ->
    list = Tuple.to_list(point)
    Enum.reduce(
      1..length(list),
      &([List.to_tuple(Enum.map(Enum.zip(list, &1), fn {p, d} -> p + d end))]),
      fn _, mapper -> &(Enum.flat_map(-1..1, fn d -> mapper.([d | &1]) end)) end
    ).([])
  end

  defp cycle(space), do: MapSet.new(
    Enum.filter(flattened_set(space, expand()), &(!(&1 in space) && nearby(space, &1) == 3))
    ++ Enum.filter(space, &(nearby(space, &1) in 2..3))
  )

  defp process(start), do: Enum.count(Enum.reduce(1..6, start, fn _, space -> cycle(space) end))

  def part1(input), do: process(parse(input, &({&1, &2, 0})))

  def part2(input), do: process(parse(input, &({&1, &2, 0, 0})))
end