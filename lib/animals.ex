defmodule Animals do
  @moduledoc """
  This is a classic AI probelm for guessing and learning the names of animals.
  """

  @doc """
  The program will ask you to think of an animal and it will ask questions until
  it discovers which animal you are thinking, or ask you to name and describe
  what you are thinking.

  """

  # List of prompts and responses used to interact with the user
  @dont_know "I'm sorry I don't know. What animal were you thinking of? "
  @get_unique_question "Great thanks. What is a question that is unique to this animal? "
  @thanks "\nThank you. I like to learn these things.\n"
  @knew_it "\nI knew it!"
  @instructions "\n\n\n\nThink of an animal and I'll try to figure it out by asking you questions.\n\n"
  @ready "Ready? "

  def convert_to_string([]) do
    "[]"
  end

  def convert_to_string(animal_list) do
    "[\"#{Enum.at(animal_list, 0)}\", \"#{Enum.at(animal_list, 1)}\", #{convert_to_string(Enum.at(animal_list, 2))}, #{convert_to_string(Enum.at(animal_list, 3))}]"
  end

  def save_to_file(animal_list) do
    File.write("animals.txt", convert_to_string(animal_list))
  end

  def convert_to_list(animal_list_string) do
IO.puts("Initial List: #{animal_list_string}")
    [animal_name, description, remainder] = String.split(animal_list_string, ~r{,}, parts: 3)
    remainder = String.trim_leading(remainder, ",")
IO.puts("Name: #{animal_name}  .Desc: #{description}   .Rem: #{remainder}")
    cond do
      String.starts_with?(remainder, "[],[]],") ->
        [[String.trim_leading(animal_name, "["), description, [], []], [convert_to_list(String.trim_leading(remainder, "[],[]],"))]]
      String.starts_with?(remainder, "[],[]]") ->
        [String.trim_leading(animal_name, "["), description, [], []]
      String.starts_with?(remainder, "[],[") ->
        [String.trim_leading(animal_name, "["), description, [], [convert_to_list(String.trim_leading(remainder, "[],"))]]
      Regex.match?(~r/[a-zA-Z]/, remainder) ->
        [String.trim_leading(animal_name, "["), description] ++ [convert_to_list(remainder)]
      true ->
        [String.trim_leading(animal_name, "["), description, [], []]
    end
  end

  def read_from_file() do
    {:ok, animal_list_string} = File.read("animals.txt")
    convert_to_list(animal_list_string)
  end

  def prompt(message, io \\ IO) do
    io.gets "#{message}"
  end

  def response(message, io \\ IO) do
    io.puts "#{message}"
  end

  def guess([], io) do
    animal = (prompt(@dont_know, io)) |> String.trim
    description = (prompt(@get_unique_question, io)) |> String.trim

    response(@thanks, io)

    ["Is it a #{animal}? ", "#{description}? ", [], []]
  end

  def guess(animal_list, io) do
    prompt_answer = prompt(Enum.at(animal_list, 1), io)    # Try description
    # prompt_answer = "no"
    if "yes" == String.trim(prompt_answer) do
      prompt_answer = prompt(List.first(animal_list), io)  # Try anaimal name
      if "yes" == String.trim(prompt_answer) do
        response(@knew_it, io)
      else
        # Go down 'yes' path since it does match description
        [Enum.at(animal_list, 0), Enum.at(animal_list, 1), guess(Enum.at(animal_list, 2), io), Enum.at(animal_list, 3)]
      end
    else
      # Go down 'no' path since the description didn't match
      [Enum.at(animal_list, 0), Enum.at(animal_list, 1), Enum.at(animal_list, 2), guess(Enum.at(animal_list, 3), io)]
    end
  end

  def start(animal_list) do
    response(@instructions)
    prompt_answer = prompt(@ready)
    if "save" == String.trim(prompt_answer) do
      save_to_file(animal_list)
    end

    start(guess(animal_list, IO))
  end

  def main(args \\ []) do
    start([])
  end

end
