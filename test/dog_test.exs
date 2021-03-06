defmodule DogTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Agent.start_link(fn -> [] end, name: __MODULE__)

    on_exit(fn -> 
      if(Process.alive?(pid), do: Agent.stop(pid))
    end)

    [pid: pid]
  end

  describe "one question" do
    test "do we choose the yes node for a yes answer" do
      data = ["Is it a Collie?", [], []]
      {data, _nput, output} = Dog.guess(data, fn() -> "y" end, [])
      
      [] = data

      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "I knew it.")
    end

    test "do we choose the no node for a no answer" do
      data = ["Is it a Collie?", [], []]
      {_ata, _nput, output} = Dog.guess(data, fn() -> "n" end, [])
      
      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "I am sorry I don't know.")
    end

    test "invalid response" do
      data = ["Is it a Collie?", [], []]

      {_ata, _nput, output} = Dog.guess(data, fn() -> "INVALID" end, [])

      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "Can't say 'INVALID'. Must answer 'y' or 'n'.")
    end

    test "valid answer with a CR on the end" do
      data = ["Is it a Collie?", [], []]
      {_ata, _nput, output} = Dog.guess(data, fn() -> "y\n" end, [])

      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "I knew it."), "Was not in #{inspect output}"
    end
  end

  describe "two question" do
    test "lovable must be a Collie" do
      data = ["Is it lovable?", ["Is it a Collie?", [], []], []]

      {data, _nput, output} = Dog.guess(data, fn() -> "y" end, [])
      assert Enum.member?(output, "Is it lovable?")
      refute Enum.member?(output, "I knew it.")

      {_ata, _nput, output} = Dog.guess(data, fn() -> "y" end, [])
      assert Enum.member?(output, "Is it a Collie?")
      assert Enum.member?(output, "I knew it.")
    end

    test "3 legs must be Bernie" do
      data = ["Does it have 4 legs?", [], ["Is it Bernie?", [], []]]

      {data, _nput, output} = Dog.guess(data, fn() -> "n" end, [])
      assert Enum.member?(output, "Does it have 4 legs?")
      refute Enum.member?(output, "I knew it.")

      {_ata, _nput, output} = Dog.guess(data, fn() -> "y" end, [])
      assert Enum.member?(output, "Is it Bernie?")
      assert Enum.member?(output, "I knew it.")
    end
  end

  describe "recursive" do
    test "choose all yes answers" do
      data = ["a",["b",["c",["d",[],[]], []], []], []]
      {_ata, output} = Dog.try_to_guess(data, fn() -> "y" end, [])

      assert Enum.member?(output, "a")
      assert Enum.member?(output, "b")
      assert Enum.member?(output, "c")
      assert Enum.member?(output, "d")
      assert Enum.member?(output, "I knew it.")
    end

    test "ended up not being the right answer" do
      data = ["a",[], ["b", [], ["c", [], ["d",[],[]]]]]
      {_ata, output} = Dog.try_to_guess(data, fn() -> "n" end, [])

      assert Enum.member?(output, "a")
      assert Enum.member?(output, "b")
      assert Enum.member?(output, "c")
      assert Enum.member?(output, "d")
      assert Enum.member?(output, "I am sorry I don't know.")
    end

    test "no initial data" do
      {data, output} = Dog.try_to_guess(["empty", [], []], fn() -> "n" end, [])

      assert ["n", ["n", [], []], []] == data

      assert Enum.member?(output, "I am sorry I don't know."), "Was not in #{inspect output}"
    end
    
  end

  describe "learn a new dog" do
    test "add second dog", context do
      input_func = expect_input(context.pid, ["n", "Is it a Beagle?","Short haired?"])

      data = ["Is it a hound?", [], []]
      {data, output} = Dog.try_to_guess(data, input_func, [])

      assert ["Is it a hound?", [], ["Short haired?", ["Is it a Beagle?", [], []], []]] == data

      assert Enum.member?(output, "What would be a good question to identify this dog?")
    end
  end

  def expect_input(pid, answers) do
    Agent.update(pid, fn _tate -> answers end)

    fn() -> 
      Agent.get_and_update(pid, fn([next_answer|answers]) -> {next_answer, answers} end) 
    end
  end
end

