defmodule Euler9ListComp do
  @moduledoc """
  Provides list comprehension solutions for Project Euler Problem 9.
  """

  @doc """
  Finds the product of the Pythagorean triplet where the sum equals `sum`.

  ## Examples

      iex> Euler9ListComp.find_triplet(1000)
      31875000

  """
  def find_triplet(sum) do
    for(
      a <- 1..(sum - 2),
      b <- (a + 1)..(sum - a - 1),
      c = sum - a - b,
      a * a + b * b == c * c,
      do: a * b * c
    )
    |> Enum.find(fn _product -> true end)
  end
end
