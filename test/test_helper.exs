defmodule AdventUtils do
  def to_list(path, index \\ false) do
    stream = File.stream!(path)
             |> Stream.map(&String.trim/1)
    Enum.to_list(if index, do: Stream.with_index(stream), else: stream)
  end

  def to_number_list(path) do
    to_list(path)
    |> Enum.map(&String.to_integer/1)
  end
end

ExUnit.start()