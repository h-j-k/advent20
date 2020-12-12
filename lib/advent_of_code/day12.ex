defmodule AdventOfCode.Day12 do
  @moduledoc "Day 12"

  defmodule Ship do
    defstruct x: 0, y: 0, face: :e

    @turns %{
      :n => [:n, :e, :s, :w],
      :s => [:s, :w, :n, :e],
      :e => [:e, :s, :w, :n],
      :w => [:w, :n, :e, :s]
    }

    def north(ship, value), do: %{ship | y: ship.y - value}
    def south(ship, value), do: %{ship | y: ship.y + value}
    def east(ship, value), do: %{ship | x: ship.x + value}
    def west(ship, value), do: %{ship | x: ship.x - value}
    def turn(ship, index), do: %{ship | face: Enum.at(@turns[ship.face], index)}
    def forward(ship, value) do
      case ship.face do
        :n -> north(ship, value)
        :s -> south(ship, value)
        :e -> east(ship, value)
        :w -> west(ship, value)
      end
    end
  end

  defp parse(line) do
    [_, heading, value] = Regex.run(~r/^([NSEWLRF])(\d+)$/, line)
    {String.to_atom(heading), String.to_integer(value)}
  end

  def part1(list) do
    last = Enum.reduce(
      list,
      %Ship{},
      fn line, ship ->
        case parse(line) do
          {:N, value} -> Ship.north(ship, value)
          {:S, value} -> Ship.south(ship, value)
          {:E, value} -> Ship.east(ship, value)
          {:W, value} -> Ship.west(ship, value)
          {:L, value} -> Ship.turn(ship, 4 - rem(div(value, 90), 4))
          {:R, value} -> Ship.turn(ship, rem(div(value, 90), 4))
          {:F, value} -> Ship.forward(ship, value)
        end
      end
    )
    IO.puts("(#{last.x}, #{last.y}) facing #{last.face}")
    abs(last.x) + abs(last.y)
  end

  def part2(list) do
    0
  end
end