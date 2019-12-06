defmodule Day02 do
  @mode_map %{
    0 => :position,
    1 => :immediate
  }

  @default_instruction %{
    opcode: nil,
    param1_mode: :position,
    param2_mode: :position,
    param3_mode: :position
  }

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
    program
    |> Enum.fetch!(curr_index)
    |> parse_instruction()
    # |> (fn instruction ->
    #       IO.inspect(instruction, label: "instruction")
    #       IO.puts("\n")
    #       instruction
    #     end).()
    |> do_instruction(program, curr_index)
  end

  def parse_instruction(instruction) do
    instruction
    |> Integer.digits()
    |> create_instruction_map()
  end

  defp create_instruction_map([opcode]) do
    %{@default_instruction | opcode: opcode}
  end

  defp create_instruction_map([_opcode_dig1, _opcode_dig2] = list) do
    opcode = Integer.undigits(list)

    %{@default_instruction | opcode: opcode}
  end

  defp create_instruction_map([param_mode, opcode_dig1, opcode_dig2]) do
    opcode = Integer.undigits([opcode_dig1, opcode_dig2])

    %{@default_instruction | opcode: opcode, param1_mode: @mode_map[param_mode]}
  end

  defp create_instruction_map([param2_mode, param1_mode, opcode_dig1, opcode_dig2]) do
    opcode = Integer.undigits([opcode_dig1, opcode_dig2])

    %{
      @default_instruction
      | opcode: opcode,
        param1_mode: @mode_map[param1_mode],
        param2_mode: @mode_map[param2_mode]
    }
  end

  defp create_instruction_map([param3_mode, param2_mode, param1_mode, opcode_dig1, opcode_dig2]) do
    opcode = Integer.undigits([opcode_dig1, opcode_dig2])

    %{
      @default_instruction
      | opcode: opcode,
        param1_mode: @mode_map[param1_mode],
        param2_mode: @mode_map[param2_mode],
        param3_mode: @mode_map[param3_mode]
    }
  end

  defp do_instruction(%{opcode: 99}, program, _curr_index) do
    program
  end

  defp do_instruction(
         %{opcode: 1} = instruction,
         program,
         curr_index
       ) do
    instruction
    |> exec_three_param(program, curr_index, &Kernel.+/2)
    |> run(curr_index + 4)
  end

  defp do_instruction(
         %{opcode: 2} = instruction,
         program,
         curr_index
       ) do
    instruction
    |> exec_three_param(program, curr_index, &Kernel.*/2)
    |> run(curr_index + 4)
  end

  defp do_instruction(
         %{opcode: 3},
         program,
         curr_index
       ) do
    input_index = Enum.fetch!(program, curr_index + 1)

    IO.write("System ID to test: ")

    input =
      :line
      |> IO.read()
      |> String.trim()
      |> String.to_integer()

    program
    |> List.update_at(input_index, fn _ -> input end)
    |> run(curr_index + 2)
  end

  defp do_instruction(
         %{opcode: 4, param1_mode: param_mode},
         program,
         curr_index
       ) do
    param = Enum.fetch!(program, curr_index + 1)
    output = get_param_value(program, param, param_mode)

    IO.puts("#{output}")

    run(program, curr_index + 2)
  end

  defp do_instruction(
         %{opcode: 5, param1_mode: param1_mode, param2_mode: param2_mode},
         program,
         curr_index
       ) do
    [param1, param2] = Enum.slice(program, curr_index + 1, 2)

    if get_param_value(program, param1, param1_mode) != 0 do
      next_instruction = get_param_value(program, param2, param2_mode)
      run(program, next_instruction)
    else
      run(program, curr_index + 3)
    end
  end

  defp do_instruction(
         %{opcode: 6, param1_mode: param1_mode, param2_mode: param2_mode},
         program,
         curr_index
       ) do
    [param1, param2] = Enum.slice(program, curr_index + 1, 2)

    if get_param_value(program, param1, param1_mode) == 0 do
      next_instruction = get_param_value(program, param2, param2_mode)
      run(program, next_instruction)
    else
      run(program, curr_index + 3)
    end
  end

  defp do_instruction(
         %{opcode: 7} = instruction,
         program,
         curr_index
       ) do
    operation = fn x, y ->
      if x < y do
        1
      else
        0
      end
    end

    instruction
    |> exec_three_param(program, curr_index, operation)
    |> run(curr_index + 4)
  end

  defp do_instruction(
         %{opcode: 8} = instruction,
         program,
         curr_index
       ) do
    operation = fn x, y ->
      if x == y do
        1
      else
        0
      end
    end

    instruction
    |> exec_three_param(program, curr_index, operation)
    |> run(curr_index + 4)
  end

  defp exec_three_param(
         %{param1_mode: param1_mode, param2_mode: param2_mode},
         program,
         curr_index,
         operation
       ) do
    [param1_index, param2_index, param3_index] = Enum.slice(program, curr_index + 1, 3)

    input1 = get_param_value(program, param1_index, param1_mode)
    input2 = get_param_value(program, param2_index, param2_mode)

    List.update_at(program, param3_index, fn _ -> operation.(input1, input2) end)
  end

  defp get_param_value(_program, param, :immediate) do
    param
  end

  defp get_param_value(program, param_index, :position) do
    Enum.fetch!(program, param_index)
  end
end

_training_program = [2, 4, 4, 5, 99, 0]

_test = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]

get_program = fn filename ->
  filename
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)
end

_noun_verb_options =
  0..99
  |> Enum.flat_map(fn x ->
    0..99
    |> Enum.map(fn y -> [x, y] end)
  end)

Day02.run(get_program.("day_05.txt"))
# Day02.run(test)
