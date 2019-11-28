defmodule Day02 do
  def calculate_paper_order(dims_list) when is_list(dims_list) do
    dims_list
    |> Enum.map(&calc_area/1)
    |> Enum.sum()
  end

  def calculate_ribbon_order(dims_list) when is_list(dims_list) do
    dims_list
    |> Enum.map(&calc_length/1)
    |> Enum.sum()
  end

  defp calc_area([l, w, h]) do
    side1 = l * w
    side2 = w * h
    side3 = l * h
    smallest = Enum.min([side1, side2, side3])

    2 * side1 + 2 * side2 + 2 * side3 + smallest
  end

  defp calc_length([l, w, h] = dims) do
    shortest_circ =
      dims
      |> Enum.sort()
      |> Enum.take(2)
      |> calc_circ()

    l * w * h + shortest_circ
  end

  defp calc_circ([side1, side2]) do
    2 * side1 + 2 * side2
  end
end

input = File.read!("day_02.txt")

parsed =
  input
  |> String.split("\n")
  |> Enum.map(fn string ->
    string
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
  end)

IO.puts(Day02.calculate_paper_order(parsed))
IO.puts(Day02.calculate_ribbon_order(parsed))
