defmodule AdventOfCode.Day18 do
  @moduledoc "Day 18"

  defp apply_module(ast, op_module) do
    quote do
      import Kernel, except: [&&: 2, &&&: 2, |||: 2]
      import unquote(op_module)
      unquote(ast)
    end
  end

  defp process(input, op_module) do
    mapper = fn line ->
      op_module.replacements
      |> Enum.reduce(line, fn {from, to}, acc -> String.replace(acc, from, to) end)
      |> Code.string_to_quoted!()
      |> apply_module(op_module)
      |> (&(elem(Code.eval_quoted(&1), 0))).()
    end
    Enum.sum(Enum.map(input, mapper))
  end

  defmodule PartOneOperators do
    def replacements, do: %{"+" => "&&", "*" => "&&&"}
    def a && b, do: a + b
    def a &&& b, do: a * b
  end

  defmodule PartTwoOperators do
    def replacements, do: %{"+" => "&&", "*" => "|||"}
    def a && b, do: a + b
    def a ||| b, do: a * b
  end

  def part1(input), do: process(input, PartOneOperators)

  def part2(input), do: process(input, PartTwoOperators)
end