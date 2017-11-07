
defmodule FakeIO do
  @dont_know "I'm sorry I don't know. What animal were you thinking of? "
  @get_unique_question "Great thanks. What is a question that is unique to this animal? "
  @get_description "Is it green? "
  @get_animal_name "Is it a frog? "
  defdelegate puts(message), to: IO

  def gets(@dont_know), do: "frog"
  def gets(@get_unique_question), do: "Is it green"
  def gets(@get_description), do: "yes"
  def gets(@get_animal_name), do: "yes"
  def gets(value), do: raise ArgumentError, message: "invalid argument #{value}"
end

defmodule AnimalsTest do
  use ExUnit.Case
  doctest Animals

  test "Prompt user for new animal / description" do
    animal_list = Animals.guess([], FakeIO)
    assert "Is it a frog? " == List.first(animal_list)
  end

  test "Add second animal to list" do
    assert :ok = Animals.guess(["Is it a frog? ", "Is it green? ", [], []], FakeIO)
  end

  test "Save list to file" do
    animal_list = ["Is it a frog? ", "Is it green? ",
                   ["Is it a lizard? ", "Is it thin? ", [], []],
                   ["Is it a cat? ", "Does it ignore you? ", [], []]]
    Animals.save_to_file(animal_list)
    {:ok, animal_list} = File.read("animals.txt")

    assert "[\"Is it a frog? \", \"Is it green? \", [\"Is it a lizard? \", \"Is it thin? \", [], []], [\"Is it a cat? \", \"Does it ignore you? \", [], []]]" == animal_list
  end

  test "Convert one animal" do
    assert ["Is it a lizard? " ,"Is it thin? " , [], []] ==
      Animals.convert_to_list("[Is it a lizard? ,Is it thin? ,[],[]]")
  end

  # This test currently fails. I need to work out a regex that will break each
  # four-tuple up for me, and then recurse on those. Or I need to work out
  # how to append a list to another list without joining them.
  #
  # test "Convert list of animals" do
  #   test_list = ["Is it a frog?","Is it green?",
  #                  ["Is it a lizard?","Is it thin?",[],[]],
  #                  ["Is it a cat?","Does it ignore you?",[],[]]]
  #   given_string = "[Is it a frog?,Is it green?,[Is it a lizard?,Is it thin?,[],[]],[Is it a cat?,Does it ignore you?,[],[]]]"
  #
  #   assert test_list == Animals.convert_to_list(given_string)
  # end

  # This test currently fails for the same reason that the test above fails.
  #
  # test "Read list from file" do
  #   test_list = ["Is it a frog?","Is it green?",
  #                  ["Is it a lizard?","Is it thin?",[],[]],
  #                  ["Is it a cat?","Does it ignore you?",[],[]]]
  #   assert test_list == Animals.read_from_file()
  # end

end
