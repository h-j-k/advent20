defmodule AdventUtils do
  def to_list(path) do
    {:ok, input} = File.read(path)
    input
    |> String.split("\r\n", trim: true)
  end

  def to_number_list(path) do
    to_list(path)
    |> Enum.map(&String.to_integer/1)
  end
end

ExUnit.start()