defmodule AdventOfCode.Day12 do
  @moduledoc "Day 12"

  defmodule PartOneShip do
    defstruct x: 0, y: 0, face: :e

    @turns [:n, :e, :s, :w]

    def north(ship, value), do: %{ship | y: ship.y - value}
    def south(ship, value), do: %{ship | y: ship.y + value}
    def east(ship, value), do: %{ship | x: ship.x + value}
    def west(ship, value), do: %{ship | x: ship.x - value}

    def turn(ship),
        do: %{ship | face: Enum.at(@turns, Enum.find_index(@turns, &(&1 == ship.face)) + 1, :n)}

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

    def turn(ship) do
      case {ship.waypoint_x, ship.waypoint_y} do
        {x, y} when x >= 0 and y < 0 -> %{ship | waypoint_x: abs(y), waypoint_y: x}
        {x, y} when x > 0 and y >= 0 -> %{ship | waypoint_x: -y, waypoint_y: x}
        {x, y} when x <= 0 and y > 0 -> %{ship | waypoint_x: -y, waypoint_y: x}
        {x, y} when x < 0 and y <= 0 -> %{ship | waypoint_x: abs(y), waypoint_y: x}
        {x, y} when x == 0 and y == 0 -> ship
      end
    end

    def forward(ship, value),
        do: %{ship | x: ship.x + ship.waypoint_x * value, y: ship.y + ship.waypoint_y * value}
  end

  @convert %{
    "R90" => ["T0"],
    "R180" => ["T0", "T0"],
    "R270" => ["T0", "T0", "T0"],
    "L90" => ["T0", "T0", "T0"],
    "L180" => ["T0", "T0"],
    "L270" => ["T0"]
  }

  defp parse(line) do
    [_, heading, value] = Regex.run(~r/^([NSEWTF])(\d+)$/, line)
    {String.to_atom(heading), String.to_integer(value)}
  end

  defp process(list, ship, processor) do
    list
    |> Enum.flat_map(&(Map.get(@convert, &1, [&1])))
    |> Enum.map(&parse/1)
    |> Enum.reduce(ship, processor)
    |> (&(abs(&1.x) + abs(&1.y))).()
  end

  def part1(list), do: process(
    list,
    %PartOneShip{},
    fn
      {:N, value}, ship -> PartOneShip.north(ship, value)
      {:S, value}, ship -> PartOneShip.south(ship, value)
      {:E, value}, ship -> PartOneShip.east(ship, value)
      {:W, value}, ship -> PartOneShip.west(ship, value)
      {:T, _}, ship -> PartOneShip.turn(ship)
      {:F, value}, ship -> PartOneShip.forward(ship, value)
    end
  )

  def part2(list), do: process(
    list,
    %PartTwoShip{},
    fn
      {:N, value}, ship -> PartTwoShip.north(ship, value)
      {:S, value}, ship -> PartTwoShip.south(ship, value)
      {:E, value}, ship -> PartTwoShip.east(ship, value)
      {:W, value}, ship -> PartTwoShip.west(ship, value)
      {:T, _}, ship -> PartTwoShip.turn(ship)
      {:F, value}, ship -> PartTwoShip.forward(ship, value)
    end
  )
end