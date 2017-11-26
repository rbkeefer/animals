defmodule Dog do
  # Main look with all input arguments defaulted
  def try_to_guess() do
    try_to_guess(
      [],
      fn() -> IO.gets(:stdio, ": ") end,
      [])
  end

  # Process a leaf node which is always the possible answer
  def try_to_guess(data = [_, [], []], input, output) do
    {_ata, _nput, output} = guess(data, input, output)
    output
  end

  def try_to_guess(data, input, output) do
    {data, input, output} = guess(data, input, output)
    try_to_guess(data, input, output)
  end

  def guess(data = [question, _, _], input, output) do
    output = ask(question, output)

    {data, output} = choose(data, input.(), output)

    {data, input, output}
  end

  defp ask(message, output) do
    write("#{message}", output)
  end

  def choose([_, [], []], "y", output) do
    {[], write("I knew it.", output)}
  end
  def choose([_, [], []], "n", output) do
    {[], write("I am sorry I don't know. What dog was it?", output)}
  end
  def choose([_, yes_node, _], "y", output) do
    {yes_node, output}
  end
  def choose([_, _, no_node], "n", output) do
    {no_node, output}
  end
  def choose(data, response, output) do
    {data, write("Can't say '#{response}'. Must answer 'y' or 'n'.", output)}
  end

  defp write(message, output) do
    IO.puts message
    output ++ [message]
  end
end
