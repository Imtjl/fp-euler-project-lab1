defmodule Euler9Recursion do
  @moduledoc """
  Module handling recursive implementations for Euler problem 9.
  """
  def find_triplet(sum) do
    do_find_triplet(1, 2, sum)
  end

  defp do_find_triplet(a, b, sum) when a < sum / 3 do
    c = sum - a - b

    cond do
      a * a + b * b == c * c ->
        a * b * c

      b < sum - a - b ->
        do_find_triplet(a, b + 1, sum)

      true ->
        do_find_triplet(a + 1, a + 2, sum)
    end
  end

  defp do_find_triplet(_, _, _), do: nil
end
