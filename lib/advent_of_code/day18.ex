defmodule AdventOfCode.Day18 do
  @moduledoc "Day 18"

  defmodule Step do
    defstruct x: nil, op: nil

    def take(%Step{x: nil, op: _}, token) when is_integer(token), do: %Step{x: token}
    def take(%Step{x: x, op: op}, token) when is_integer(token), do: %Step{x: op.(x, token)}
    def take(step, "+"), do: %{step | op: &+/2}
    def take(step, "*"), do: %{step | op: &*/2}
    def take(%Step{x: _, op: nil}, last) when is_struct(last), do: last
    def take(%Step{x: x, op: op}, last) when is_struct(last), do: %Step{x: op.(x, last.x)}
  end

  defp parse(line), do: Enum.reduce(
    String.graphemes(String.replace(line, " ", "")),
    [%Step{}],
    fn v, [step | rest] ->
      case (if Regex.match?(~r/^\d+$/, v), do: String.to_integer(v), else: v) do
        "(" -> [%Step{}, step | rest]
        ")" -> [Step.take(hd(rest), step) | tl(rest)]
        token -> [Step.take(step, token) | rest]
      end
    end
  )

  defp process(line), do: hd(parse(line)).x

  def part1(input), do: Enum.sum(Enum.map(input, &process/1))

  def part2(_input), do: 0
end