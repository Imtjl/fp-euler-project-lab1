defmodule Euler21TailRecursion do
  def sum_amicable_numbers(limit) do
    do_sum(2, limit, 0)
  end

  defp do_sum(n, limit, acc) when n < limit do
    sum_div = sum_of_divisors(n)

    if sum_div != n and sum_of_divisors(sum_div) == n do
      do_sum(n + 1, limit, acc + n)
    else
      do_sum(n + 1, limit, acc)
    end
  end

  defp do_sum(_, _, acc), do: acc

  defp sum_of_divisors(n), do: sum_of_divisors(n, n - 1, 0)

  defp sum_of_divisors(_, 0, acc), do: acc

  defp sum_of_divisors(n, i, acc) do
    if rem(n, i) == 0 do
      sum_of_divisors(n, i - 1, acc + i)
    else
      sum_of_divisors(n, i - 1, acc)
    end
  end
end
