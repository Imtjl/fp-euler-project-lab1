defmodule Euler21Test do
  use ExUnit.Case

  @expected 31_626

  test "Euler21Recursion" do
    assert Euler21Recursion.sum_amicable_numbers(10_000) == @expected
  end

  test "Euler21TailRecursion" do
    assert Euler21TailRecursion.sum_amicable_numbers(10_000) == @expected
  end

  test "Euler21Modular" do
    assert Euler21Modular.sum_amicable_numbers(10_000) == @expected
  end

  test "Euler21Map" do
    assert Euler21Map.sum_amicable_numbers(10_000) == @expected
  end

  test "Euler21ListComp" do
    assert Euler21ListComp.sum_amicable_numbers(10_000) == @expected
  end

  test "Euler21Stream" do
    assert Euler21Stream.sum_amicable_numbers(10_000) == @expected
  end
end
