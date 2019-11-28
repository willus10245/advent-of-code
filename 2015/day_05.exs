defmodule Day05 do
  def check_list(names) when is_list(names) do
    names
    |> Stream.reject(&has_bad_sequence/1)
    |> Stream.filter(&has_three_vowels/1)
    |> Enum.filter(&has_double_letter/1)
    |> length()
  end

  def new_rules(names) when is_list(names) do
    names
    |> Stream.filter(&has_matching_pair/1)
    |> Enum.filter(&has_aba/1)
    |> length()
  end

  defp has_bad_sequence(name) do
    Regex.match?(~r/ab|cd|pq|xy/, name)
  end

  defp has_three_vowels(name) do
    vowels = Regex.scan(~r/[aeiou]/, name)
    length(vowels) >= 3
  end

  defp has_double_letter(name) do
    Regex.match?(~r/(.)\1/, name)
  end

  defp has_matching_pair(name) do
    Regex.match?(~r/(..).*\1/, name)
  end

  defp has_aba(name) do
    Regex.match?(~r/(.).\1/, name)
  end
end

input =
  "day_05.txt"
  |> File.read!()
  |> String.split("\n")

# input = [
#   "aeiouaeiouaeiou",
#   "ugknbfddgicrmopn",
#   "jchzalrnumimnmhp",
#   "haegwjzuvuyypxyu",
#   "dvszwmarrgswjxmb",
#   "aaa"
# ]

IO.puts(Day05.check_list(input))
IO.puts(Day05.new_rules(input))
