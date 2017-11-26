defmodule Bugs do

  def guess(data) do
    guess(data, fn -> IO.gets(:stdio, ": ") end)
  end

  def guess(data, input) when is_bitstring(input) do
    guess(data, fn -> input end)
  end

  def guess(data, input) do
    choice = data
      |> ask
      |> answer(input)

    choice
    |> choose(data)
  end

  defp ask(data = [question, _, _]) do
    IO.puts question
    data
  end

  defp answer(_, input) do
    input.()
  end

  defp choose("y", [_, yes_node, _]) do
    yes_node 
  end
  defp choose("n", [_, _, no_node]) do
    no_node 
  end
end
