defmodule Day01 do
  def calc_fuel_total(masses) when is_list(masses) do
    masses
    |> Enum.map(&calc_fuel/1)
    |> Enum.sum()
  end

  defp calc_fuel(mass) when mass <= 0 do
    0
  end

  defp calc_fuel(mass) do
    fuel_for_mass =
      mass
      |> Kernel./(3)
      |> trunc()
      |> Kernel.-(2)

    max(fuel_for_mass + calc_fuel(fuel_for_mass), 0)
  end
end

parsed_input =
  "day_01.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

IO.inspect(Day01.calc_fuel_total(parsed_input))
