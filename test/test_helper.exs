defmodule AdventOfCode.TestUtils do

  import Stream, only: [reject: 2, chunk_by: 2, map: 2, with_index: 1]

  defmacro test_file(opts \\ []) do
    empty_line = &(&1 == "")
    grouped = fn s -> reject(chunk_by(s, empty_line), &(Enum.all?(&1, empty_line))) end
    apply_if = fn (s, opt, apply) -> if Keyword.get(opts, opt, false), do: apply.(s), else: s end
    Atom.to_string(__CALLER__.module)
    |> (&(Regex.replace(~r/^.*Day(\d\d)Test$/, &1, "./inputs/day\\1.txt"))).()
    |> File.stream!
    |> map(&String.trim/1)
    |> apply_if.(:grouped, grouped)
    |> apply_if.(:flattened, &(map(grouped.(&1), fn v -> Enum.join(v, " ") end)))
    |> apply_if.(:to_integer, &(map(&1, fn v -> String.to_integer(v) end)))
    |> apply_if.(:indexed, &with_index/1)
    |> Enum.to_list
  end
end

ExUnit.start()