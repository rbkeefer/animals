defmodule BugsTest do
  use ExUnit.Case

  describe "keep trying" do
    data = Bugs.try_to_guess(
      fn(data, input) -> {data ++ ["value"], input} end,
      [],
      fn() -> "some input" end,
      2)

    assert data == ["value", "value"]

  end

  describe "no data" do
    test "teach that a fly is winged" do
      {output, data} = Bugs.guess([], "Is it winged?")
      assert String.contains?(output, "I am sorry I don't know. What bug was it?")
      assert String.contains?(output, "What would be a good question to identify this bug?")

      {output, _ata} = Bugs.guess(data, "Is it winged?")
      assert String.contains?(output, "Great thanks.")
    end

    test "if the bug is an empty string. ask again" do
      {output, data} = Bugs.guess([], "")
      {output, data} = Bugs.guess(data, "fly")
      {output, data} = Bugs.guess(data, "Is it winged?")

      assert String.contains?(output, "I am sorry I don't know. What bug was it?")
      assert String.contains?(output, "I didn't understand that. What bug was it?")
      assert String.contains?(output, "What would be a good question to identify this bug?")
      assert String.contains?(output, "Great thanks.")
    end
  end

  describe "know of one bug" do
    test "a winged fly" do
      data = ["Is it winged?", ["Is it a fly?", [], []], []]

      {output, data} = Bugs.guess(data, "y")
      assert String.contains?(output, "Is it winged?")

      {output, data} = Bugs.guess(data, "y")
      assert String.contains?(output, "Is it a fly?")
      assert String.contains?(output, "I knew it.")
    end

    test "its not winged" do
      data = ["Is it winged?", ["Is it a fly?", [], []], []]
      {output, data} = Bugs.guess(data, "n")
      {output, data} = Bugs.guess(data, "ant")
      {output, data} = Bugs.guess(data, "Does it have six legs?")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "I am sorry I don't know. What bug was it?")
      assert String.contains?(output, "What would be a good question to identify this bug?")
      assert String.contains?(output, "Great thanks.")
    end
  end

  describe "know of two bug" do
    test "a winged fly" do
      data = ["Is it winged?", ["Is it a fly", [], []], ["Does it have six leg?", ["Is it an ant?", [], []]]]
      {output, data} = Bugs.guess(data, "y")
      {output, data} = Bugs.guess(data, "y")
      {output, data} = Bugs.guess(data, "y")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "Is it a fly?")
      assert String.contains?(output, "I knew it.")
    end

    test "a six legged ant" do
      data = ["Is it winged?", ["Is it a fly", [], []], ["Does it have six leg?", ["Is it an ant?", [], []]]]
      {output, data} = Bugs.guess(data, "y")
      {output, data} = Bugs.guess(data, "n")
      {output, data} = Bugs.guess(data, "y")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "Does it have six legs?")
      assert String.contains?(output, "Is it an ant?")
      assert String.contains?(output, "I knew it.")
    end
  end

  describe "learning a new bug" do
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

      {_utput, data} = Bugs.guess(data, "y")
      {_utput, data} = Bugs.guess(data, "n")
      {_utput, data} = Bugs.guess(data, "y")
      {output, _ata} = Bugs.guess(data, "y")

      assert String.contains?(output, "Is it winged?")
      assert String.contains?(output, "Is it hairy?")
      assert String.contains?(output, "Is it a pack bug?")
      assert String.contains?(output, "Is it a llama?")
      assert String.contains?(output, "I knew it.")
    end
  end
  
end

