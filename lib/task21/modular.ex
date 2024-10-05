defmodule Euler21Modular do
  @moduledoc """
  Provides modular solutions for Project Euler Problem 21.
  """

  @doc """
  Sums all amicable numbers below `limit` using modular functions.

  ## Examples

      iex> Euler21Modular.sum_amicable_numbers(10000)
      31626

  """
  def sum_amicable_numbers(limit) do
    2..(limit - 1)
    |> Enum.filter(&amicable?/1)
    |> Enum.sum()
  end

  defp amicable?(n) do
    sum_div = sum_of_divisors(n)
    sum_div != n and sum_div < limit() and sum_of_divisors(sum_div) == n
  end

  defp sum_of_divisors(n) do
    1..(div(n, 2))
    |> Enum.filter(&(rem(n, &1) == 0))
    |> Enum.sum()
  end

  defp limit, do: 10_000
end
