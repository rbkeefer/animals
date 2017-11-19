defmodule Animals do
  @moduledoc """
  This is a classic AI probelm for guessing and learning the names of animals.
  """

  @doc """
  The program will ask you to think of an animal and it will ask questions until
  it discovers which animal you are thinking, or ask you to name and describe
  what you are thinking.

  """

  require Poison

  # List of prompts and responses used to interact with the user
  @dont_know "I'm sorry I don't know. What animal were you thinking of? "
  @get_unique_question "Great thanks. What is a question that is unique to this animal? "
  @thanks "\nThank you. I like to learn these things.\n"
  @knew_it "\nI knew it!"
  @instructions "\n\n\n\nThink of an animal and I'll try to figure it out by asking you questions.\n\n"
  @ready "Ready? "

  def save_to_file(animal_list) do
    File.write("animals.txt", Poison.encode!(animal_list))
  end

  def read_from_file() do
    {:ok, animal_list_string} = File.read("animals.txt")
    Poison.decode!(animal_list_string)
  end

  def prompt(message, io \\ IO) do
    (io.gets "#{message}") |> String.trim
  end

  def response(message, io \\ IO) do
    io.puts "#{message}"
  end

  def guess([], io) do
    # Create a new node at the bottom of the tree
    animal = prompt(@dont_know, io)
    description = prompt(@get_unique_question, io)

    response(@thanks, io)

    ["Is it a #{animal}? ", "#{description}? ", [], []]
  end

  def guess(answer_list=[answer, question, yes_node, no_node], io) do
    prompt_answer = prompt(question, io)    # Try description
    process_question(prompt_answer, answer_list, io)
  end

  def process_question("yes", answer_list=[answer, question, yes_node, no_node], io) do
    prompt_answer = prompt(answer, io)  # Try anaimal name
    process_answer(prompt_answer, answer_list, io)
  end

  def process_question("no", [answer, question, yes_node, no_node], io) do
    # Go down 'no' path since the description didn't match
    [answer, question, yes_node, guess(no_node, io)]
  end

  def process_answer("yes", answer_list=[answer, question, yes_node, no_node], io) do
    # Found the right animal
    response(@knew_it, io)
    answer_list
  end

  def process_answer("no", [answer, question, yes_node, no_node], io) do
    # Go down 'yes' path since it does match description, but is not the right animal
    [answer, question, guess(yes_node, io), no_node]
  end

  def start(animal_list) do
    response(@instructions)
    prompt_answer = prompt(@ready)
    if "save" == prompt_answer do
      save_to_file(animal_list)
    end
    if "load" == prompt_answer do
      animal_list = read_from_file()
    end

    start(guess(animal_list, IO))
  end

  def main(args \\ []) do
    start([])
  end

end
