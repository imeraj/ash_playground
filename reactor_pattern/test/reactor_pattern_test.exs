defmodule ReactorPatternTest do
  use ExUnit.Case
  doctest ReactorPattern

  test "greets the world" do
    assert ReactorPattern.hello() == :world
  end
end
