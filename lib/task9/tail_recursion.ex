defmodule Euler9TailRecursion do
  def find_triplet(sum) do
    do_find_triplet(1, 2, sum)
  end

  defp do_find_triplet(a, b, sum) when a < sum / 3 do
    c = sum - a - b

    if a * a + b * b == c * c do
      a * b * c
    else
      cond do
        b < sum - a - b ->
          do_find_triplet(a, b + 1, sum)

        true ->
          do_find_triplet(a + 1, a + 2, sum)
      end
    end
  end

  defp do_find_triplet(_, _, _), do: nil
end
