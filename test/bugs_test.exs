defmodule BugsTest do
  use ExUnit.Case

  description "no data" do
    test "teach that a fly is winged" do
      {_utput, data} = Bug.guess([], "fly")
      {output, _ata} = Bug.guess(data, "Is it winged?")

      assert String.contains?(output, "I am sorry I don't know. What animal was it?")
      assert String.contains?(output, "What would be a good question to identify this animal?")
      assert String.contains?(output, "Great thanks.")
    end

    test "if the animal is an empty string. ask again" do
      {output, data} = Bug.guess([], "")
      {output, data} = Bug.guess(data, "fly")
      {output, data} = Bug.guess(data, "Is it winged?")

      assert String.contains?(output, "I am sorry I don't know. What animal was it?")
      assert String.contains?(output, "I didn't understand that. What animal was it?")
      assert String.contains?(output, "What would be a good question to identify this animal?")
      assert String.contains?(output, "Great thanks.")
    end
  end

  describe "know of one animal" do
    test "a winged fly" do
      {output, data} = Bug.guess(["Is it winged?", ["Is it a fly?", [], []], []], "y")
      {output, data} = Bug.guess(["Is it winged?", ["Is it a fly?", [], []], []], "y")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "Is it a fly?")
      assert String.contains?(output, "I knew it.")
    end

    test "its not winged" do
      data = ["Is it winged?", ["Is it a fly?", [], []], []]
      {output, data} = Bug.guess(data, "n")
      {output, data} = Bug.guess(data, "ant")
      {output, data} = Bug.guess(data, "Does it have six legs?")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "I am sorry I don't know. What animal was it?")
      assert String.contains?(output, "What would be a good question to identify this animal?")
      assert String.contains?(output, "Great thanks.")
    end
  end

  describe "know of two animal" do
    test "a winged fly" do
      data = ["Is it winged?", ["Is it a fly", [], []], ["Does it have six leg?", ["Is it an ant?", [], []]]]
      {output, data} = Bug.guess(data, "y")
      {output, data} = Bug.guess(data, "y")
      {output, data} = Bug.guess(data, "y")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "Is it a fly?")
      assert String.contains?(output, "I knew it.")
    end

    test "a six legged ant" do
      data = ["Is it winged?", ["Is it a fly", [], []], ["Does it have six leg?", ["Is it an ant?", [], []]]]
      {output, data} = Bug.guess(data, "y")
      {output, data} = Bug.guess(data, "n")
      {output, data} = Bug.guess(data, "y")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "Does it have six legs?")
      assert String.contains?(output, "Is it an ant?")
      assert String.contains?(output, "I knew it.")
    end
  end

  describe "learning a new animal" do
    test "learn about beatles" do
      data = [
        "Is it winged?", 
        [
          "Is it a fly", 
          [], 
          []
        ], 
        [
          "Does it have six leg?", 
          [
            "Is it an ant?", 
            [], 
            []
          ]
        ]
      ]

      {_utput, data} = Bug.guess(data, "y")
      {_utput, data} = Bug.guess(data, "n")
      {_utput, data} = Bug.guess(data, "y")
      {output, _ata} = Bug.guess(data, "y")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "Is it hairy?")
      assert String.contains?(output, "Is it a pack animal?")
      assert String.contains?(output, "Is it a llama?")
      assert String.contains?(output, "I knew it.")
    end
  end
  
end

