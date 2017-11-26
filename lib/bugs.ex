defmodule Bugs do

  # Main look with all input arguments defaulted
  def try_to_guess() do
    try_to_guess(
      fn(data, input) -> Bugs.guess(data, input) end,
      [],
      fn() -> IO.gets(:stdio, ": ") end,
      100)
  end

  # Abstract recursive loop from loop behavior to allow
  # tests to verify individual guess loops.
  def try_to_guess(_uess, data, _nput, 0), do: data
  def try_to_guess(guess_func, data, input, count) do
    {data, input} = guess_func.(data, input)
    try_to_guess(guess_func, data, input, count - 1)
  end

  # Simplify testing of single guess by allowing single string inputs
  def guess(data, input) when is_bitstring(input) do
    guess(data, fn -> input end)
  end

  def guess([], input) do
    learn(input)
  end

  def guess(data, input) do
    choice = data
      |> ask
      |> answer(input)

    choice
    |> choose(data)
  end

  # Don't kow what the animal is so collect a question with the animal as the right answer.
  def learn(input) do
    IO.puts("I am sorry I don't know. What bug was it?")
    bug_name = input.()

    IO.puts("What would be a good quesiotn to idenfity this animal?")
    question = input.()

    [question, ["Is it a #{bug_name}?", [], []], []]
  end

  defp ask(data = [question, _, _]) do
    IO.puts "Question: #{question}"
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
