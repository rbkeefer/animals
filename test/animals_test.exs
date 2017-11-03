defmodule AnimalsTest do
  use ExUnit.Case
  doctest Animals

  test "Prompt user for new animal / description" do
    animal_list = Animals.get_guess([])
    assert "cat" == List.first(animal_list)
  end

  test "Add second animal to list" do
    animal_list = Animals.add_new_animal_to_list("frog", "Is it green?")
    assert :ok == Animals.get_guess(animal_list)
  end

end
