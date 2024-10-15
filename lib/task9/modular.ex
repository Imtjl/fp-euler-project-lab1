defmodule Euler9Modular do
  @moduledoc """
  Module handling Euler problem 9 with clear separation of generation, filtering, and folding.
  """

  def find_triplet(sum) do
    generate_triplets(sum)
    |> filter_triplets()
    |> fold_triplets()
  end

  defp generate_triplets(sum) do
    1..(sum - 2)
    |> Enum.flat_map(fn a ->
      (a + 1)..(sum - a - 1)
      |> Enum.map(fn b ->
        c = sum - a - b
        {a, b, c}
      end)
    end)
  end

  defp filter_triplets(triplets) do
    triplets
    |> Enum.filter(fn {a, b, c} -> a * a + b * b == c * c end)
  end

  defp fold_triplets(triplets) do
    Enum.reduce(triplets, nil, fn {a, b, c}, _acc ->
      a * b * c
    end)
  end
end
