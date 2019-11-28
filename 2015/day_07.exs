defmodule Day07 do
  use Bitwise

  def eval(_map, value) when is_number(value) do
    value
  end

  def eval(map, value) when is_atom(value) do
    eval(map, Map.get(map, value))
  end

  def eval(map, {:not, input}) do
    ~~~eval(map, input)
  end

  def eval(map, {:and, {input1, input2}}) do
    IO.inspect("#{input1} &&& #{input2}")
    eval(map, input1) &&& eval(map, input2)
  end

  def eval(map, {:or, {input1, input2}}) do
    eval(map, input1) ||| eval(map, input2)
  end

  def eval(map, {:lshift, {input1, input2}}) do
    eval(map, input1) <<< eval(map, input2)
  end

  def eval(map, {:rshift, {input1, input2}}) do
    eval(map, input1) >>> eval(map, input2)
  end

  def parse_instruction([val, _arrow, output]) do
    {:assign, parse_to_atom_or_number(val), String.to_atom(output)}
  end

  def parse_instruction(["NOT", input, _arrow, output]) do
    {:not, String.to_atom(input), String.to_atom(output)}
  end

  def parse_instruction([input1, operation, input2, _arrow, output]) do
    operation_atom =
      operation
      |> String.downcase()
      |> String.to_atom()

    {
      operation_atom,
      {parse_to_atom_or_number(input1), parse_to_atom_or_number(input2)},
      String.to_atom(output)
    }
  end

  defp parse_to_atom_or_number(string) do
    case Integer.parse(string) do
      :error ->
        String.to_atom(string)

      {number, ""} ->
        number
    end
  end
end

parsed_input =
  "day_07.txt"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.split/1)
  |> Enum.map(&Day07.parse_instruction/1)
  |> Map.new(fn {operation, inputs, output} ->
    case operation do
      :assign ->
        {output, inputs}

      _ ->
        {output, {operation, inputs}}
    end
  end)

IO.inspect(Day07.eval(parsed_input, :a))
