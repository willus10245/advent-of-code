defmodule Day04 do
  def mine_coins(input) do
    do_mining(input, 0)
  end

  defp do_mining(input, number) do
    with hash <- :crypto.hash(:md5, input <> to_string(number)),
         <<?0, ?0, ?0, ?0, ?0, ?0>> <> _rest <- Base.encode16(hash) do
      number
    else
      _ -> do_mining(input, number + 1)
    end
  end
end

IO.puts(Day04.mine_coins("ckczppom"))
