defmodule Euler9Stream do
  @moduledoc """
  Module handling lazy collections and infinite lists for Euler problem 9.
  """
  def find_triplet(sum) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.take_while(&(&1 < sum / 3))
    |> Stream.flat_map(fn a ->
      Stream.iterate(a + 1, &(&1 + 1))
      |> Stream.take_while(&(&1 < sum / 2))
      |> Stream.map(fn b ->
        c = sum - a - b
        {a, b, c}
      end)
    end)
    |> Stream.filter(fn {a, b, c} -> a * a + b * b == c * c end)
    |> Enum.map(fn {a, b, c} -> a * b * c end)
    |> Enum.at(0)
  end
end
