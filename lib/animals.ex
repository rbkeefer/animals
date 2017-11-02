defmodule Animals do
  @moduledoc """
  This is a classic AI probelm for guessing and learning the names of animals.
  """

  @doc """
  The program will ask you to think of an animal and it will ask questions until
  it discovers which animal you are thinking, or ask you to name and describe
  what you are thinking.

  """

  def get_new_animal_name() do
    IO.gets "I'm sorry I don't know. What animal were you thinking of? " |> String.trim
  end

  def get_new_animal_description() do
    IO.gets "Great thanks. What is a question that is unique to this animal? " |> String.trim
  end

  def try_prompt(prompt) do
    IO.puts(inspect(prompt))
    IO.gets "#{prompt}" |> String.trim
  end


  def get_guess([]) do
    animal = get_new_animal_name()
    description = get_new_animal_description()
    # animal = "cat"
    # description = "Does it ignore you?"

    [animal, description, [], []]
  end

  def get_guess(animal_list) do
    prompt_answer = IO.gets try_prompt(Enum.at(animal_list, 1))    # Try description
    # prompt_answer = "no"
    if prompt_answer == "yes" do
      prompt_answer = IO.gets try_prompt(List.first(animal_list))  # Try anaimal name
      if prompt_answer == "yes" do
        IO.puts "I knew it!"
      else
        # Go down 'yes' path since it does match description
        [Enum.at(animal_list, 0), Enum.at(animal_list, 1), get_guess(Enum.at(animal_list, 2)), Enum.at(animal_list, 3)]
      end
    else
      # Go down 'no' path since it didn't match
      [Enum.at(animal_list, 0), Enum.at(animal_list, 1), Enum.at(animal_list, 2), get_guess(Enum.at(animal_list, 3))]
    end
  end


  # def add_new_animal_to_list(animal, descriptive_question) do
  #   animal_list = [animal, descriptive_question, [], []]
  # end
  #
  # def add_new_animal_to_list(animal, descriptive_question, no_list, yes_list) do
  #   animal_list = [animal, descriptive_question, no_list, yes_list]
  # end

end
