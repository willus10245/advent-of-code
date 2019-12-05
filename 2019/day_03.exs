defmodule Day03 do
  def find_closest_intersection(wire1, wire2) do
    wire1
    |> find_intersections(wire2)
    |> Enum.map(fn {x, y, _} -> abs(x) + abs(y) end)
    |> Enum.min()
  end

  def find_shortest_path_intersection(wire1, wire2) do
    wire1
    |> find_intersections(wire2)
    |> Enum.map(fn {_x, _y, steps} -> steps end)
    |> Enum.min()
  end

  def find_intersections(wire1, wire2) do
    wire1
    |> Enum.reduce([], &find_intersections(&1, &2, wire2))
    |> List.flatten()
  end

  defp find_intersections(range, list_of_ints, list_of_ranges) do
    intersections = Enum.reduce(list_of_ranges, [], &check_for_intersection(&1, range, &2))

    [intersections | list_of_ints]
  end

  defp check_for_intersection(
         {x, {y1, _y2}, steps1} = range1,
         {{x1, _x2}, y, steps2} = range2,
         list_of_ints
       ) do
    if has_intersection?(range1, range2) do
      [{x, y, steps1 + abs(x - x1) + steps2 + abs(y - y1)} | list_of_ints]
    else
      list_of_ints
    end
  end

  defp check_for_intersection(
         {{x1, _x2}, y, steps1} = range1,
         {x, {y1, _y2}, steps2} = range2,
         list_of_ints
       ) do
    if has_intersection?(range2, range1) do
      [{x, y, steps1 + abs(x - x1) + steps2 + abs(y - y1)} | list_of_ints]
    else
      list_of_ints
    end
  end

  defp check_for_intersection(_, _, list_of_ints) do
    list_of_ints
  end

  defp has_intersection?({x, {y1, y2}, _}, {{x1, x2}, y, _}) do
    x1 < x and x < x2 and y1 < y and y < y2
  end

  def generate_ranges(instructions) do
    generate_ranges(instructions, {0, {0, 0}, 0}, :U)
  end

  defp generate_ranges([], _last_range, _prev_dir) do
    []
  end

  defp generate_ranges([{dir, _} = next_instruction | rest_instructions], last_range, prev_dir) do
    range = generate_range(next_instruction, last_range, prev_dir)
    [range | generate_ranges(rest_instructions, range, dir)]
  end

  defp generate_range({:U, amount}, {{x_min, x_max}, y, step}, prev_dir) do
    starting_x = if(prev_dir == :L, do: x_min, else: x_max)
    {starting_x, {y, y + amount}, step + abs(x_max - x_min)}
  end

  defp generate_range({:D, amount}, {{x_min, x_max}, y, step}, prev_dir) do
    starting_x = if(prev_dir == :L, do: x_min, else: x_max)
    {starting_x, {y - amount, y}, step + abs(x_max - x_min)}
  end

  defp generate_range({:L, amount}, {x, {y_min, y_max}, step}, prev_dir) do
    starting_y = if(prev_dir == :D, do: y_min, else: y_max)
    {{x - amount, x}, starting_y, step + abs(y_max - y_min)}
  end

  defp generate_range({:R, amount}, {x, {y_min, y_max}, step}, prev_dir) do
    starting_y = if(prev_dir == :D, do: y_min, else: y_max)
    {{x, x + amount}, starting_y, step + abs(y_max - y_min)}
  end
end

[wire1, wire2] =
  "day_03.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.split(&1, ","))
  |> Enum.map(fn wire_list ->
    wire_list
    |> Enum.map(&Regex.named_captures(~r/(?<dir>[DLRU])(?<amount>\d+)/, &1))
    |> Enum.map(fn %{"amount" => amount, "dir" => dir} ->
      {
        String.to_atom(dir),
        String.to_integer(amount)
      }
    end)
  end)
  |> Enum.map(&Day03.generate_ranges/1)

# IO.inspect(wire2)

IO.inspect(Day03.find_closest_intersection(wire1, wire2))
IO.inspect(Day03.find_shortest_path_intersection(wire1, wire2))
