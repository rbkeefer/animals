defmodule Dog do
  def guess(data = [question, _, _], input) do
    output = ask(question, [])

    {data, output} = choose(data, input.(), output)

    {data, input, output}
  end

  defp ask(message, output) do
    IO.puts message
    output ++ [message]
  end

  def choose([_, [], []], "y", output) do
    {[], output ++ ["I knew it."]}
  end
  def choose([_, [], []], "n", output) do
    {[], output ++ ["I am sorry I don't know. What dog was it?"]}
  end
  def choose([_, yes_node, _], "y", output) do
    {yes_node, output}
  end
  def choose([_, _, no_node], "n", output) do
    {no_node, output}
  end
  def choose(data, response, output) do
    {data, output ++ ["Can't say '#{response}'. Must answer 'y' or 'n'."]}
  end
end
