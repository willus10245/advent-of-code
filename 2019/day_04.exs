defmodule Day04 do
  defguard is_six_digit_number(number)
           when is_number(number) and number >= 100_000 and number <= 999_999

  def count_valid_passwords(range) do
    range
    |> Enum.filter(&is_valid_password/1)
    |> length()
  end

  def is_valid_password(password) when is_six_digit_number(password) do
    has_repeated_digit_part_2(password) and increases?(password)
  end

  def has_repeated_digit(password) do
    password
    |> to_string()
    |> (&Regex.match?(~r/(\d)\1/, &1)).()
  end

  def has_repeated_digit_part_2(password) do
    password
    |> to_string()
    |> (&Regex.scan(~r/(\d)\1+/, &1, capture: :first)).()
    |> List.flatten()
    |> Enum.any?(&(String.length(&1) == 2))
  end

  defp increases?(password) do
    password
    |> Integer.digits()
    |> Enum.sort()
    |> Integer.undigits()
    |> Kernel.==(password)
  end
end

IO.inspect(Day04.count_valid_passwords(254_032..789_860))
