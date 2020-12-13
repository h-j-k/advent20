defmodule AdventOfCode.Day12 do
  @moduledoc "Day 12"

  defmodule PartOneShip, do: defstruct x: 0, y: 0, face: :E

  defmodule PartTwoShip, do: defstruct x: 0, y: 0, waypoint_x: 10, waypoint_y: -1

  defprotocol Ship do
    def turn(ship)
    def forward(ship, value)
  end

  defimpl Ship, for: PartOneShip do
    @turns [:N, :E, :S, :W]

    def turn(ship),
        do: %{face: Enum.at(@turns, Enum.find_index(@turns, &(&1 == ship.face)) + 1, :N)}

    def forward(ship, value) do
      case ship.face do
        :N -> %{y: ship.y - value}
        :S -> %{y: ship.y + value}
        :E -> %{x: ship.x + value}
        :W -> %{x: ship.x - value}
      end
    end
  end

  defimpl Ship, for: PartTwoShip do
    def turn(ship) do
      case {ship.waypoint_x, ship.waypoint_y} do
        {x, y} when x >= 0 and y < 0 -> %{waypoint_x: abs(y), waypoint_y: x}
        {x, y} when x > 0 and y >= 0 -> %{waypoint_x: -y, waypoint_y: x}
        {x, y} when x <= 0 and y > 0 -> %{waypoint_x: -y, waypoint_y: x}
        {x, y} when x < 0 and y <= 0 -> %{waypoint_x: abs(y), waypoint_y: x}
        {x, y} when x == 0 and y == 0 -> %{}
      end
    end

    def forward(ship, value),
        do: %{x: ship.x + ship.waypoint_x * value, y: ship.y + ship.waypoint_y * value}
  end

  defp parse(line) do
    [_, heading, value] = Regex.run(~r/^([NSEWLRF])(\d+)$/, line)
    turn = {:T, nil}
    case {String.to_atom(heading), String.to_integer(value)} do
      n when n == {:R, 90} or n == {:L, 270} -> [turn]
      n when n == {:R, 180} or n == {:L, 180} -> [turn, turn]
      n when n == {:R, 270} or n == {:L, 90} -> [turn, turn, turn]
      result -> [result]
    end
  end

  defp process(list, ship, processor),
       do: Enum.flat_map(list, &parse/1)
           |> Enum.reduce(ship, &(Map.merge(&2, processor.(&1, &2))))
           |> (&(abs(&1.x) + abs(&1.y))).()

  def part1(list), do: process(
    list,
    %PartOneShip{},
    fn
      {:T, _}, ship -> Ship.turn(ship)
      {:F, value}, ship -> Ship.forward(ship, value)
      {direction, value}, ship -> Ship.forward(%{ship | face: direction}, value)
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