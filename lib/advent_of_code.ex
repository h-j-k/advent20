defmodule AdventOfCode do
  @moduledoc """
  For Advent of Code 2020
  """

  def count_chars(string), do: Enum.frequencies(String.graphemes(string))
end
