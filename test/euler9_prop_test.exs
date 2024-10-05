defmodule Euler9PropTest do
  use ExUnit.Case
  use PropCheck

  property "find_triplet returns correct product for sum 1000" do
    forall _ <- integer() do
      product = Euler9Modular.find_triplet(1000)
      product == 31_875_000
    end
  end
end
