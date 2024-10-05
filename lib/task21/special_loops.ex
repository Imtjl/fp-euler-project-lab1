defmodule Euler21ListComp do
  @moduledoc """
  Provides list comprehension solutions for Project Euler Problem 21.
  """

  @doc """
  Sums all amicable numbers below `limit`.

  ## Examples

      iex> Euler21ListComp.sum_amicable_numbers(10000)
      31626

  """
  def sum_amicable_numbers(limit) do
    for(
      n <- 2..(limit - 1),
      amicable?(n),
      do: n
    )
    |> Enum.sum()
  end

  defp amicable?(n) do
    sum_div = sum_of_divisors(n)
    sum_div != n and sum_div < limit() and sum_of_divisors(sum_div) == n
  end

  defp sum_of_divisors(n) do
    for(
      i <- 1..div(n, 2),
      rem(n, i) == 0,
      do: i
    )
    |> Enum.sum()
  end

  defp limit, do: 10_000
end
