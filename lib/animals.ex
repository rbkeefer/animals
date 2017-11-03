defmodule Animals do
  @moduledoc """
  This is a classic AI probelm for guessing and learning the names of animals.
  """

  @doc """
  The program will ask you to think of an animal and it will ask questions until
  it discovers which animal you are thinking, or ask you to name and describe
  what you are thinking.

  """

  def try_prompt(prompt) do
    IO.gets "#{prompt}"
  end

  def get_guess([]) do
    animal = (IO.gets "I'm sorry I don't know. What animal were you thinking of? ") |> String.trim
    description = (IO.gets "Great thanks. What is a question that is unique to this animal? ") |> String.trim

    ["Is it a #{animal}? ", "#{description}? ", [], []]
  end

  def get_guess(animal_list) do
    prompt_answer = try_prompt(Enum.at(animal_list, 1))    # Try description
    # prompt_answer = "no"
    if "yes" == String.trim(prompt_answer) do
      prompt_answer = try_prompt(List.first(animal_list))  # Try anaimal name
      if "yes" == String.trim(prompt_answer) do
        IO.puts "I knew it!"
      else
        # Go down 'yes' path since it does match description
        [Enum.at(animal_list, 0), Enum.at(animal_list, 1), get_guess(Enum.at(animal_list, 2)), Enum.at(animal_list, 3)]
      end
    else
      # Go down 'no' path since the description didn't match
      [Enum.at(animal_list, 0), Enum.at(animal_list, 1), Enum.at(animal_list, 2), get_guess(Enum.at(animal_list, 3))]
    end
  end

end
