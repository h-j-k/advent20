defmodule AdventOfCode.Day18 do
  @moduledoc "Day 18"

  defmodule Step do
    defstruct x: nil, op: nil

    def take(step, token) when is_integer(token), do:
      (if step.x == nil, do: [Map.merge(step, %{x: token})], else: [%Step{x: step.op.(step.x, token)}])

    def take(step, "+"), do: [%{step | op: &(&1 + &2)}]
    def take(step, "*"), do: [%{step | op: &(&1 * &2)}]
    def take(step, "("), do: [step, %Step{}]
    def take(step, ")"), do: [step]
    def take(%Step{x: _, op: nil}, last) when is_struct(last), do: last
    def take(%Step{x: x, op: op}, last) when is_struct(last), do: %Step{x: op.(x, last.x)}
  end

  defp parse(line), do: hd(
    Enum.reduce(
      String.graphemes(String.replace(line, " ", "")),
      [%Step{}],
      fn v, [step | rest] ->
        token = (if Regex.match?(~r/^\d+$/, v), do: String.to_integer(v), else: v)
        Enum.reduce(
          Step.take(step, token),
          rest,
          fn x, acc -> if token == ")", do: [Step.take(hd(acc), x) | tl(acc)], else: [x | acc] end
        )
      end
    )
  ).x

  def part1(input), do: Enum.sum(Enum.map(input, &parse/1))

  def part2(_input), do: 0
end