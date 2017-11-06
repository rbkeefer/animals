defmodule Animals do
  @moduledoc """
  This is a classic AI probelm for guessing and learning the names of animals.
  """

  @doc """
  The program will ask you to think of an animal and it will ask questions until
  it discovers which animal you are thinking, or ask you to name and describe
  what you are thinking.

  """

  def prompt(prompt) do
    IO.gets "#{prompt}"
  end

  def guess([]) do
    animal = (IO.gets "I'm sorry I don't know. What animal were you thinking of? ") |> String.trim
    description = (IO.gets "Great thanks. What is a question that is unique to this animal? ") |> String.trim

    IO.puts "\nThank you. I like to learn these things.\n"

    ["Is it a #{animal}? ", "#{description}? ", [], []]
  end

  def guess(animal_list) do
    prompt_answer = prompt(Enum.at(animal_list, 1))    # Try description
    # prompt_answer = "no"
    if "yes" == String.trim(prompt_answer) do
      prompt_answer = prompt(List.first(animal_list))  # Try anaimal name
      if "yes" == String.trim(prompt_answer) do
        IO.puts "\nI knew it!"
      else
        # Go down 'yes' path since it does match description
        [Enum.at(animal_list, 0), Enum.at(animal_list, 1), guess(Enum.at(animal_list, 2)), Enum.at(animal_list, 3)]
      end
    else
      # Go down 'no' path since the description didn't match
      [Enum.at(animal_list, 0), Enum.at(animal_list, 1), Enum.at(animal_list, 2), guess(Enum.at(animal_list, 3))]
    end
  end

  def start(animal_list) do
    IO.puts "\n\n\n\nThink of an animal and I'll try to figure it out by asking you questions.\n\n"
    IO.gets "Ready? "
    IO.puts "\n"
    start(guess(animal_list))
  end

  def main(args \\ []) do
    start([])
  end

end
