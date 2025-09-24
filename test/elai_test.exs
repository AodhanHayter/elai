defmodule ElaiTest do
  use ExUnit.Case
  doctest Elai

  test "greets the world" do
    assert Elai.hello() == :world
  end
end
