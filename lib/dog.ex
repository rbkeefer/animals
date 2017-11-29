defmodule Dog do
  # Main look with all input arguments defaulted
  def try_to_guess() do
    root_node = ["empty", [], []]
    input_func = fn() -> IO.gets(:stdio, ": ") end
    output = []

    try_to_guess(root_node, input_func, output)
  end

  # Process a leaf node which is always the possible answer
  def try_to_guess(node = [_, [], []], input, output) do
    {next_node, _nput, output} = guess(node, input, output)
    {next_node, output}
  end

  # Loop through guesses
  def try_to_guess(node, input, output) do
    {next_node, input, output} = guess(node, input, output)
    try_to_guess(next_node, input, output)
  end

  # The first loop must skip the choice and just create a new 
  # root node representing the first entry in the data.
  def guess(node = ["empty", _, _], input, output) do
    {["empty", [], next_node], output} = choose(node, "n", input, output)
    {next_node, input, output}
  end
  def guess(node = [question, _, _], input, output) do
    {choice, output} = prompt(question, input, output)

    {next_node, output} = choose(node, choice, input, output)

    {next_node, input, output}
  end

  defp choose([_, [], []], "y", _nput, output) do
    {[], write(output, "I knew it.")}
  end
  defp choose(node = [_, [], []], "n", input, output) do
    output = write(output, "I am sorry I don't know.")

    learn(node, input, output)
  end
  defp choose([_, yes_node, _], "y", _nput, output) do
    {yes_node, output}
  end
  defp choose([_, _, no_node], "n", _nput, output) do
    {no_node, output}
  end
  defp choose(node, response, _nput, output) do
    {node, write(output, "Can't say '#{response}'. Must answer 'y' or 'n'.")}
  end

  defp learn([question, _es_node, no_node], input, output) do
    {new_answer, output}   = prompt("What was it?", input, output)
    {new_question, output} = prompt("What would be a good question to identify this dog?", input, output)

    learned_node = [question, no_node, [new_question, [new_answer, [], []], []]]
    {learned_node, output}
  end

  defp prompt(question, input, output) do
    output = write(output, question)
    answer = String.trim(input.())
    {answer, output}
  end

  defp write(output, message) do
    IO.puts message
    output ++ [message]
  end
end
