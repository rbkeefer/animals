defmodule DogTest do
  use ExUnit.Case

  describe "one question" do
    test "do we choose the yes node for a yes answer" do
      data = ["Is it a Collie?", [], []]
      {data, _nput, output} = Dog.guess(data, fn() -> "y" end)
      
      [] = data

      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "I knew it.")
    end

    test "do we choose the no node for a no answer" do
      data = ["Is it a Collie?", [], []]
      {data, _nput, output} = Dog.guess(data, fn() -> "n" end)
      
      [] = data

      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "I am sorry I don't know. What dog was it?")
    end

    test "invalid response" do
      data = ["Is it a Collie?", [], []]

      {_ata, _nput, output} = Dog.guess(data, fn() -> "INVALID" end)

      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "Can't say 'INVALID'. Must answer 'y' or 'n'.")
    end
  end

  describe "two question" do
    test "lovable must be a Collie" do
      data = ["Is it lovable?", ["Is it a Collie?", [], []], []]

      {data, _nput, output} = Dog.guess(data, fn() -> "y" end)
      assert Enum.member?(output, "Is it lovable?")
      refute Enum.member?(output, "I knew it.")

      {_ata, _nput, output} = Dog.guess(data, fn() -> "y" end)
      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "I knew it.")
    end

    test "3 legs must be Bernie" do
      data = ["Does it have 4 legs?", [], ["Is it Bernie?", [], []]]

      {data, _nput, output} = Dog.guess(data, fn() -> "n" end)
      assert Enum.member?(output, "Does it have 4 legs?")
      refute Enum.member?(output, "I knew it.")

      {_ata, _nput, output} = Dog.guess(data, fn() -> "y" end)
      assert Enum.member?(output, "Is it Bernie?")
      assert Enum.member?(output, "I knew it.")
    end
  end
end

