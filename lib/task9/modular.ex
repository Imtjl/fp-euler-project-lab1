defmodule Euler9Modular do
  @moduledoc """
  Module handling modular implementations for Euler problem 9.
  """
  def find_triplet(sum) do
    1..(sum - 2)
    |> Enum.flat_map(fn a ->
      (a + 1)..(sum - a - 1)
      |> Enum.map(fn b ->
        c = sum - a - b
        {a, b, c}
      end)
    end)
    |> Enum.filter(fn {a, b, c} -> a * a + b * b == c * c end)
    |> Enum.map(fn {a, b, c} -> a * b * c end)
    |> Enum.at(0)
  end
end
