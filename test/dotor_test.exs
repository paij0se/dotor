defmodule DotorTest do
  use ExUnit.Case
  doctest Dotor

  test "greets the world" do
    assert Dotor.hello() == :world
  end
end
