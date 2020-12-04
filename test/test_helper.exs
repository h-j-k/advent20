defmodule AdventUtils do
  def to_list(path, opts \\ []) do
    empty_line = &(&1 == "")
    line_delimited = fn s -> Stream.reject(Stream.chunk_by(s, empty_line), &(Enum.all?(&1, empty_line))) end
    process_if = fn (s, opt, process) -> if Keyword.get(opts, opt, false), do: process.(s), else: s end
    map_if = fn (s, opt, mapper) -> process_if.(s, opt, &(Stream.map(&1, mapper))) end
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> process_if.(:line_delimited, line_delimited)
    |> map_if.(:flattened, &(Enum.join(&1, " ")))
    |> map_if.(:to_integer, &String.to_integer/1)
    |> process_if.(:indexed, &Stream.with_index/1)
    |> Enum.to_list
  end
end

ExUnit.start()