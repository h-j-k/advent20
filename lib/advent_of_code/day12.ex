defmodule AdventOfCode.Day12 do
  @moduledoc "Day 12"

  defmodule PartOneShip, do: defstruct x: 0, y: 0, face: :e

  defmodule PartTwoShip, do: defstruct x: 0, y: 0, waypoint_x: 10, waypoint_y: -1

  defprotocol Ship do
    def turn(ship)
    def forward(ship, value)
  end

  defimpl Ship, for: PartOneShip do
    @turns [:n, :e, :s, :w]

    def turn(ship),
        do: %{ship | face: Enum.at(@turns, Enum.find_index(@turns, &(&1 == ship.face)) + 1, :n)}

    def forward(ship, value) do
      case ship.face do
        :n -> %{y: ship.y - value}
        :s -> %{y: ship.y + value}
        :e -> %{x: ship.x + value}
        :w -> %{x: ship.x - value}
      end
    end
  end

  defimpl Ship, for: PartTwoShip do
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
    |> Enum.reduce(ship, &(Map.merge(&2, processor.(&1, &2))))
    |> (&(abs(&1.x) + abs(&1.y))).()
  end

  def part1(list), do: process(
    list,
    %PartOneShip{},
    fn
      {:N, value}, ship -> %{y: ship.y - value}
      {:S, value}, ship -> %{y: ship.y + value}
      {:E, value}, ship -> %{x: ship.x + value}
      {:W, value}, ship -> %{x: ship.x - value}
      {:T, _}, ship -> Ship.turn(ship)
      {:F, value}, ship -> Ship.forward(ship, value)
    end
  )

  def part2(list), do: process(
    list,
    %PartTwoShip{},
    fn
      {:N, value}, ship -> %{waypoint_y: ship.waypoint_y - value}
      {:S, value}, ship -> %{waypoint_y: ship.waypoint_y + value}
      {:E, value}, ship -> %{waypoint_x: ship.waypoint_x + value}
      {:W, value}, ship -> %{waypoint_x: ship.waypoint_x - value}
      {:T, _}, ship -> Ship.turn(ship)
      {:F, value}, ship -> Ship.forward(ship, value)
    end
  )
end