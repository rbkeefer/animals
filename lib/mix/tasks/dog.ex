defmodule Mix.Tasks.Animals.Dog do
  use Mix.Task

  @shortdoc "What kind of dog is it."

  def run([]) do
    Dog.try_to_guess()
  end
end

