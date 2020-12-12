defmodule AdventOfCode.Day12 do
  @moduledoc "Day 12"

  defmodule PartOneShip do
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

  defmodule PartTwoShip do
    defstruct x: 0, y: 0, waypoint_x: 10, waypoint_y: -1

    def north(ship, value), do: %{ship | waypoint_y: ship.waypoint_y - value}
    def south(ship, value), do: %{ship | waypoint_y: ship.waypoint_y + value}
    def east(ship, value), do: %{ship | waypoint_x: ship.waypoint_x + value}
    def west(ship, value), do: %{ship | waypoint_x: ship.waypoint_x - value}

    def turn(ship, index) do
      case index do
        0 -> ship
        1 ->
          case {ship.waypoint_x, ship.waypoint_y} do
            {x, y} when x == 0 and y < 0 -> %{ship | waypoint_x: abs(y), waypoint_y: x}
            {x, y} when x > 0 and y < 0 -> %{ship | waypoint_x: abs(y), waypoint_y: x}
            {x, y} when x > 0 and y == 0 -> %{ship | waypoint_x: y, waypoint_y: x}
            {x, y} when x > 0 and y > 0 -> %{ship | waypoint_x: -y, waypoint_y: x}
            {x, y} when x == 0 and y > 0 -> %{ship | waypoint_x: -y, waypoint_y: x}
            {x, y} when x < 0 and y > 0 -> %{ship | waypoint_x: -y, waypoint_y: -x}
            {x, y} when x < 0 and y == 0 -> %{ship | waypoint_x: y, waypoint_y: -x}
            {x, y} when x < 0 and y < 0 -> %{ship | waypoint_x: abs(y), waypoint_y: -x}
          end
        2 ->
          case {ship.waypoint_x, ship.waypoint_y} do
            {x, y} when x == 0 and y < 0 -> %{ship | waypoint_x: x, waypoint_y: abs(y)}
            {x, y} when x > 0 and y < 0 -> %{ship | waypoint_x: -x, waypoint_y: abs(y)}
            {x, y} when x > 0 and y == 0 -> %{ship | waypoint_x: -x, waypoint_y: y}
            {x, y} when x > 0 and y > 0 -> %{ship | waypoint_x: -x, waypoint_y: -y}
            {x, y} when x == 0 and y > 0 -> %{ship | waypoint_x: x, waypoint_y: -y}
            {x, y} when x < 0 and y > 0 -> %{ship | waypoint_x: abs(x), waypoint_y: -y}
            {x, y} when x < 0 and y == 0 -> %{ship | waypoint_x: abs(x), waypoint_y: y}
            {x, y} when x < 0 and y < 0 -> %{ship | waypoint_x: abs(x), waypoint_y: abs(y)}
          end
        3 ->
          case {ship.waypoint_x, ship.waypoint_y} do
            {x, y} when x == 0 and y < 0 -> %{ship | waypoint_x: y, waypoint_y: x}
            {x, y} when x > 0 and y < 0 -> %{ship | waypoint_x: y, waypoint_y: -x}
            {x, y} when x > 0 and y == 0 -> %{ship | waypoint_x: y, waypoint_y: -x}
            {x, y} when x > 0 and y > 0 -> %{ship | waypoint_x: y, waypoint_y: -x}
            {x, y} when x == 0 and y > 0 -> %{ship | waypoint_x: y, waypoint_y: x}
            {x, y} when x < 0 and y > 0 -> %{ship | waypoint_x: y, waypoint_y: abs(x)}
            {x, y} when x < 0 and y == 0 -> %{ship | waypoint_x: y, waypoint_y: abs(x)}
            {x, y} when x < 0 and y < 0 -> %{ship | waypoint_x: y, waypoint_y: abs(x)}
          end
      end
    end

    def forward(ship, value) do
      %{ship | x: ship.x + ship.waypoint_x * value, y: ship.y + ship.waypoint_y * value}
    end
  end

  defp parse(line) do
    [_, heading, value] = Regex.run(~r/^([NSEWLRF])(\d+)$/, line)
    {String.to_atom(heading), String.to_integer(value)}
  end

  def part1(list) do
    last = Enum.reduce(
      list,
      %PartOneShip{},
      fn line, ship ->
        case parse(line) do
          {:N, value} -> PartOneShip.north(ship, value)
          {:S, value} -> PartOneShip.south(ship, value)
          {:E, value} -> PartOneShip.east(ship, value)
          {:W, value} -> PartOneShip.west(ship, value)
          {:L, value} -> PartOneShip.turn(ship, 4 - rem(div(value, 90), 4))
          {:R, value} -> PartOneShip.turn(ship, rem(div(value, 90), 4))
          {:F, value} -> PartOneShip.forward(ship, value)
        end
      end
    )
    abs(last.x) + abs(last.y)
  end

  def part2(list) do
    last = Enum.reduce(
      list,
      %PartTwoShip{},
      fn line, ship ->
        r = case parse(line) do
          {:N, value} -> PartTwoShip.north(ship, value)
          {:S, value} -> PartTwoShip.south(ship, value)
          {:E, value} -> PartTwoShip.east(ship, value)
          {:W, value} -> PartTwoShip.west(ship, value)
          {:L, value} -> PartTwoShip.turn(ship, 4 - rem(div(value, 90), 4))
          {:R, value} -> PartTwoShip.turn(ship, rem(div(value, 90), 4))
          {:F, value} -> PartTwoShip.forward(ship, value)
        end
        IO.puts("#{line} | #{r.x}, #{r.y} | #{r.waypoint_x}, #{r.waypoint_y}")
        r
      end
    )
    abs(last.x) + abs(last.y)
  end
end