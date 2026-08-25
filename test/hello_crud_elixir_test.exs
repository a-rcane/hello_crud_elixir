defmodule HelloCrudElixirTest do
  use ExUnit.Case
  doctest HelloCrudElixir

  test "greets the world" do
    assert HelloCrudElixir.hello() == :world
  end
end
