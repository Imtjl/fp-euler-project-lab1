defmodule Euler9Test do
  use ExUnit.Case

  @expected 31_875_000

  test "Euler9Recursion" do
    assert Euler9Recursion.find_triplet(1000) == @expected
  end

  test "Euler9TailRecursion" do
    assert Euler9TailRecursion.find_triplet(1000) == @expected
  end

  test "Euler9Modular" do
    assert Euler9Modular.find_triplet(1000) == @expected
  end

  test "Euler9Map" do
    assert Euler9Map.find_triplet(1000) == @expected
  end

  test "Euler9ListComp" do
    assert Euler9ListComp.find_triplet(1000) == @expected
  end

  test "Euler9Stream" do
    assert Euler9Stream.find_triplet(1000) == @expected
  end
end
