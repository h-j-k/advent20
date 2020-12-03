defmodule AdventUtils do
  def to_list(path, opts \\ []) do
    number = Keyword.get(opts, :number, false)
    index = Keyword.get(opts, :index, false)
    stream = File.stream!(path)
             |> Stream.map(&String.trim/1)
    stream = if number, do: Stream.map(stream, &String.to_integer/1), else: stream
    Enum.to_list(if index, do: Stream.with_index(stream), else: stream)
  end
end

ExUnit.start()