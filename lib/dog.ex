defmodule Dog do
  # Main look with all input arguments defaulted
  def try_to_guess() do
    try_to_guess(
      ["", [], []],
      fn() -> IO.gets(:stdio, ": ") end,
      [])
  end

  # Process a leaf node which is always the possible answer
  def try_to_guess(data = [_, [], []], input, output) do
    {data, _nput, output} = guess(data, input, output)
    {data, output}
  end

  # Loop through guesses
  def try_to_guess(data, input, output) do
    {data, input, output} = guess(data, input, output)
    try_to_guess(data, input, output)
  end

  def guess(data = [question, _, _], input, output) do
    {choice, output} = prompt(question, input, output)

    {data, output} = choose(data, choice, input, output)

    {data, input, output}
  end

  defp choose([_, [], []], "y", _nput, output) do
    {[], write(output, "I knew it.")}
  end
  defp choose(data = [_, [], []], "n", input, output) do
    output = write(output, "I am sorry I don't know.")

    learn(data, input, output)
  end
  defp choose([_, yes_node, _], "y", _nput, output) do
    {yes_node, output}
  end
  defp choose([_, _, no_node], "n", _nput, output) do
    {no_node, output}
  end
  defp choose(data, response, _nput, output) do
    {data, write(output, "Can't say '#{response}'. Must answer 'y' or 'n'.")}
  end

  defp learn([question, _es_node, no_node], input, output) do
    {new_answer, output}   = prompt("What was it?", input, output)
    {new_question, output} = prompt("What would be a good question to identify this dog?", input, output)

    data = [question, no_node, [new_question, [new_answer, [], []], []]]
    {data, output}
  end

  defp prompt(question, input, output) do
    output = write(output, question)
    answer = input.()
    output = write(output, "Answer: #{answer}")
    {answer, output}
  end

  defp write(output, message) do
    IO.puts message
    output ++ [message]
  end
end
