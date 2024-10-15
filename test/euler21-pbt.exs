defmodule Euler21PropTest do
  use ExUnit.Case
  use PropCheck

  alias Euler21Modular

  @doc """
  Проверяем, что функция находит только дружественные числа.
  """
  property "sum_amicable_numbers correctly identifies amicable pairs" do
    forall limit <- choose(100, 10_000) do
      # Берём все дружественные числа ниже лимита
      amicable_numbers = Enum.filter(2..limit, &Euler21Modular.amicable?/1)

      # Проверяем, что для каждого числа его пара тоже дружественная
      Enum.all?(amicable_numbers, fn a ->
        b = Euler21Modular.sum_of_divisors(a)
        b != a and b < limit and Euler21Modular.sum_of_divisors(b) == a
      end)
    end
  end

  @doc """
  Проверяем, что функция суммирует правильные значения.
  """
  property "sum_amicable_numbers returns correct sum of amicable numbers" do
    forall limit <- choose(100, 10_000) do
      # Получаем сумму всех дружественных чисел для лимита
      result = Euler21Modular.sum_amicable_numbers(limit)

      # Проверяем, что сумма совпадает с ручным вычислением через filter + sum
      manual_sum =
        2..limit
        |> Enum.filter(&Euler21Modular.amicable?/1)
        |> Enum.sum()

      result == manual_sum
    end
  end
end
