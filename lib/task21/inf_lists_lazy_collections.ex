defmodule Euler21Stream do
  @moduledoc """
  Provides stream-based solutions for Project Euler Problem 21.
  """

  @doc """
  Sums all amicable numbers below `limit` using streams.

  ## Examples

      iex> Euler21Stream.sum_amicable_numbers(10000)
      31626

  """
  def sum_amicable_numbers(limit) do
    Stream.iterate(2, &(&1 + 1))
    |> Stream.take_while(&(&1 < limit))
    |> Stream.filter(&amicable?/1)
    |> Enum.sum()
  end

  defp amicable?(n) do
    sum_div = sum_of_divisors(n)
    sum_div != n and sum_div < limit() and sum_of_divisors(sum_div) == n
  end

  defp sum_of_divisors(n) do
    1..(div(n, 2))
    |> Stream.filter(&(rem(n, &1) == 0))
    |> Enum.sum()
  end

  defp limit, do: 10_000
end
