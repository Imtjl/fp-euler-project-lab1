defmodule Euler21Map do
  @moduledoc """
  Provides map-based solutions for Project Euler Problem 21.
  """

  @doc """
  Sums all amicable numbers below `limit` using map functions.

  ## Examples

      iex> Euler21Map.sum_amicable_numbers(10000)
      31626

  """
  def sum_amicable_numbers(limit) do
    2..(limit - 1)
    |> Enum.map(&{&1, sum_of_divisors(&1)})
    |> Enum.filter(fn {n, sum_div} ->
      sum_div != n and sum_div < limit and sum_of_divisors(sum_div) == n
    end)
    |> Enum.map(fn {n, _} -> n end)
    |> Enum.sum()
  end

  defp sum_of_divisors(n) do
    1..(div(n, 2))
    |> Enum.filter(&(rem(n, &1) == 0))
    |> Enum.sum()
  end
end
