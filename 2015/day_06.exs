defmodule Day06 do
  def light_show(instructions) when is_list(instructions) do
    instructions
    |> Enum.reduce(%{}, &do_instruction/2)
    |> Map.values()
    |> Enum.sum()

    # |> Enum.filter(&(&1 == :on))
    # |> length()
  end

  defp do_instruction({switch, {start_x, start_y}, {end_x, end_y}}, grid) do
    for x <- start_x..end_x, y <- start_y..end_y, reduce: grid do
      acc -> toggle_light(switch, acc, {x, y})
    end
  end

  defp toggle_light(:on, grid, coord),
    do: Map.update(grid, coord, 1, &(&1 + 1))

  defp toggle_light(:off, grid, coord),
    do: Map.update(grid, coord, 0, &max(0, &1 - 1))

  defp toggle_light(:toggle, grid, coord),
    do: Map.update(grid, coord, 2, &(&1 + 2))

  defp old_toggle_light(:on, grid, coord),
    do: Map.update(grid, coord, :on, fn _ -> :on end)

  defp old_toggle_light(:off, grid, coord),
    do: Map.update(grid, coord, :off, fn _ -> :off end)

  defp old_toggle_light(:toggle, grid, coord),
    do: Map.update(grid, coord, :on, &toggle/1)

  defp toggle(:on), do: :off
  defp toggle(:off), do: :on

  def parse_instruction([switch, start_at, _through, end_at]) do
    {
      String.to_atom(switch),
      parse_coords(start_at),
      parse_coords(end_at)
    }
  end

  def parse_instruction(list) do
    list
    |> Enum.drop(1)
    |> parse_instruction()
  end

  defp parse_coords(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end

parsed_input =
  "day_06.txt"
  |> File.read!()
  |> String.split("\n")
  |> Stream.map(&String.split/1)
  |> Enum.map(&Day06.parse_instruction/1)

IO.inspect(Day06.light_show(parsed_input))
