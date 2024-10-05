defmodule Euler9Map do
  @moduledoc """
  Module handling sequence map implementations for Euler problem 9.
  """
  def find_triplet(sum) do
    for a <- 1..(sum - 2),
        b <- (a + 1)..(sum - a - 1),
        c = sum - a - b,
        a * a + b * b == c * c do
      a * b * c
    end
    |> Enum.at(0)
  end
end
