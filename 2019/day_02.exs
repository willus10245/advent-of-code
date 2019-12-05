defmodule Day02 do
  def find_noun_verb(program, [[noun, verb] | rest_options]) do
    outcome =
      program
      |> List.update_at(1, fn _ -> noun end)
      |> List.update_at(2, fn _ -> verb end)
      |> run()
      |> hd()

    if outcome == 19_690_720 do
      noun * 100 + verb
    else
      find_noun_verb(program, rest_options)
    end
  end

  def run(program) when is_list(program) do
    run(program, 0)
  end

  defp run(program, curr_index) do
    case Enum.fetch!(program, curr_index) do
      99 ->
        program

      1 ->
        program
        |> exec_three_param(curr_index, &Kernel.+/2)
        |> run(curr_index + 4)

      2 ->
        program
        |> exec_three_param(curr_index, &Kernel.*/2)
        |> run(curr_index + 4)

      _ ->
        {:error, "unknown opcode"}
    end
  end

  defp exec_three_param(program, curr_index, operation) do
    [input1_index, input2_index, output_index] = Enum.slice(program, curr_index + 1, 3)

    input1 = Enum.fetch!(program, input1_index)
    input2 = Enum.fetch!(program, input2_index)

    List.update_at(program, output_index, fn _ -> operation.(input1, input2) end)
  end
end

_training_program = [2, 4, 4, 5, 99, 0]

real_program =
  "day_02.txt"
  |> File.read!()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

_noun_verb_options =
  0..99
  |> Enum.flat_map(fn x ->
    0..99
    |> Enum.map(fn y -> [x, y] end)
  end)

IO.inspect(Day02.run(real_program))
