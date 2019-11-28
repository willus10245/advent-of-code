defmodule Day03 do
  @visited_map %{
    0 => [0]
  }

  def santa_journey(instructions) do
    instructions
    |> do_instructions()
    |> get_num_houses_visited()
  end

  def robo_santa_journey(instructions) do
    instructions
    |> do_robo_instructions()
    |> get_num_houses_visited()
  end

  defp get_num_houses_visited(visited_locations) do
    visited_locations
    |> Map.values()
    |> List.flatten()
    |> length()
  end

  defp do_instructions(instructions) do
    do_instruction(instructions, {0, 0}, @visited_map)
  end

  defp do_instruction("", _current_location, visited_locations) do
    visited_locations
  end

  defp do_instruction(
         <<next_inst::binary-size(1), rest_instructions::binary>>,
         {_x, _y} = current_location,
         visited_locations
       ) do
    new_location = get_new_location(next_inst, current_location)

    do_instruction(
      rest_instructions,
      new_location,
      update_visited_locations(new_location, visited_locations)
    )
  end

  defp do_robo_instructions(instructions) do
    do_robo_instruction(instructions, {0, 0}, {0, 0}, :human, @visited_map)
  end

  defp do_robo_instruction("", _human_loc, _robo_loc, _next, visited_locations) do
    visited_locations
  end

  defp do_robo_instruction(
         <<next_inst::binary-size(1), rest_instructions::binary>>,
         {_x1, _y1} = human_current_location,
         {_x2, _y2} = robo_current_location,
         :human,
         visited_locations
       ) do
    new_location = get_new_location(next_inst, human_current_location)

    do_robo_instruction(
      rest_instructions,
      new_location,
      robo_current_location,
      :robo,
      update_visited_locations(new_location, visited_locations)
    )
  end

  defp do_robo_instruction(
         <<next_inst::binary-size(1), rest_instructions::binary>>,
         {_x1, _y1} = human_current_location,
         {_x2, _y2} = robo_current_location,
         :robo,
         visited_locations
       ) do
    new_location = get_new_location(next_inst, robo_current_location)

    do_robo_instruction(
      rest_instructions,
      human_current_location,
      new_location,
      :human,
      update_visited_locations(new_location, visited_locations)
    )
  end

  defp get_new_location("^", {x, y}), do: {x, y + 1}
  defp get_new_location("v", {x, y}), do: {x, y - 1}
  defp get_new_location(">", {x, y}), do: {x + 1, y}
  defp get_new_location("<", {x, y}), do: {x - 1, y}

  defp update_visited_locations({x, y}, visited_locations) do
    Map.update(visited_locations, x, [y], fn list ->
      case y in list do
        true ->
          list

        false ->
          [y | list]
      end
    end)
  end
end

input = File.read!("day_03.txt")

IO.puts(Day03.santa_journey(input))
IO.puts(Day03.robo_santa_journey(input))
