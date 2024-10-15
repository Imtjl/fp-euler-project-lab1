# Лабораторная работа №1 (Проект Эйлера)

---

- Студент: `Дворкин Борис Александрович`
- Группа: `P3331`
- ИСУ: `368090`
- Функциональный язык программирования: `Elixir`

---

## Проблема №9

---

- Название: `Special Pythagorean Triplet`
- Описание:  
   A Pythagorean triplet is a set of three natural numbers, $a < b < c$, for which  
  $$a^2 + b^2 = c^2$$  
  For example, $3^2 + 4^2 = 9 + 16 = 25 = 5^2$.  
  There exists exactly one Pythagorean triplet for which $a + b + c = 1000$.
- Задание: `Find the product abc.`

---

### Основная идея решения

Конечно, задачу можно банально решить полным перебором, как я и сделал на
императивном языке `Python`. Но в функциональных языках принято пользоваться
_рекурсией_ и _функциями высшего порядка_, а также фильтрацией, генерацией и
другими концепциями, поэтому для различных ситуаций пришлось придумать другие
решения.

Для рекурсии идея состоит в следующем:

Установим $a = 1$ и $b = 2$, как обычно вычислим $c = \text{sum} - a - b$ и
проверим, удовлетворяют ли $a$, $b$, $c$ условию Пифагоровой тройки.

Теперь заметим, что $a < b < c$ (по условию), а значит, можно записать условия
перебора для каждой переменной, а потом просто рекурсивно вызывать функцию, либо
увеличивая $b$, либо увеличивая $a$, при этом не забывая проверять, что
$a < b < c$.

А именно:

- если $b < c$, то можно безопасно увеличить $b$ на 1 и вызвать функцию для
  этого значения.
  - Так как $c = \text{sum} - a - b$, то получаем условие
    $b < \text{sum} - a - b$.
- Иначе, это значит, что мы перебрали все возможные значения $b$ для данного
  $a$, поэтому "сбрасываем" значение $b$, делая его на 1 больше, чем $a$, так
  как $a < b < c$.

### Рекурсивное решение

```elixir
defmodule Euler9Recursion do
@moduledoc """
Module handling recursive implementations for Euler problem 9.
"""
def find_triplet(sum) do
  do_find_triplet(1, 2, sum)
end

defp do_find_triplet(a, b, sum) when a < sum / 3 do
  c = sum - a - b

  cond do
    a * a + b * b == c * c ->
      a * b * c

    b < sum - a - b ->
      do_find_triplet(a, b + 1, sum)

    true ->
      do_find_triplet(a + 1, a + 2, sum)
  end
end

defp do_find_triplet(_, _, _), do: nil
end
```

### Решение с хвостовой рекурсией

- то есть особого вида рекурсией, где любой рекурсивный вызов - последний перед
  возвратом из функции, что позволяет выполнять `tail call optimisation`

```elixir
defmodule Euler9TailRecursion do
  @moduledoc """
  Module handling tail-recursive implementations for Euler problem 9.
  """
  def find_triplet(sum) do
    do_find_triplet(1, 2, sum)
  end

  defp do_find_triplet(a, b, sum) when a < sum / 3 do
    c = sum - a - b

    if a * a + b * b == c * c do
      a * b * c
    else
      if b < sum - a - b do
        do_find_triplet(a, b + 1, sum)
      else
        do_find_triplet(a + 1, a + 2, sum)
      end
    end
  end

  defp do_find_triplet(_, _, _), do: nil
end
```

### Модульная реализация (генерация, фильтрация, свёртка)

- Генерация последовательности при помощи отображения (map)

```elixir
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
```

- зачем тут flat_map? Если сделать просто map, вот, что будет:

```
[
  [{1, 2, 997}, {1, 3, 996}, {1, 4, 995}, ...],
  [{2, 3, 995}, {2, 4, 994}, {2, 5, 993}, ...],
  ...
]
```

а `flat_map` _выпрямит_, чтобы далее было легко фильтровать каждый кортеж:

```
[
  {1, 2, 997},
  {1, 3, 996},
  {1, 4, 995},
  ...
]
```

### Решение с использованием специального синтаксиса для циклов (Comprehensions)

```elixir
defmodule Euler9ListComp do
  @moduledoc """
  Provides list comprehension solutions for Project Euler Problem 9.
  """

  @doc """
  Finds the product of the Pythagorean triplet where the sum equals `sum`.

  ## Examples

      iex> Euler9ListComp.find_triplet(1000)
      31875000

  """
  def find_triplet(sum) do
    for(
      a <- 1..(sum - 2),
      b <- (a + 1)..(sum - a - 1),
      c = sum - a - b,
      a * a + b * b == c * c,
      do: a * b * c
    )
    |> Enum.find(fn _product -> true end)
  end
end
```

### Бесконечные потоки чисел, ленивые коллекции

```elixir
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
```

### Реализация на удобном императивном языке (Python)

```elixir
def find_pyth_triplet(sum_):
    for a in range(1, sum_):
        for b in range(1, sum_):
            c = 1000 - a - b
            if a**2 + b**2 == c**2:
                return a, b, c


a, b, c = find_pyth_triplet(1000)
print(f"Pythagorean triplet: a = {a}. b = {b}, c = {c}")
print(f"Product abc = {a * b * c}")
```

## Проблема №21

---

- Название: `Amicable Numbers`
- Описание:  
   Let $d(n)$ be defined as the sum of proper divisors of $n$ (numbers less than
  $n$ which divide evenly into $n$).  
   If $d(a) = b$ and $d(b) = a$, where $a \neq b$, then $a$ and $b$ are an
  amicable pair and each of $a$ and $b$ are called amicable numbers.

  For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44,
  55, and 110; therefore  
   $$d(220) = 284.$$  
   The proper divisors of 284 are 1, 2, 4, 71, and 142; so  
   $$d(284) = 220.$$

- Задание: `Evaluate the sum of all the amicable numbers under 10000.`

---

### Основная идея решения

В этой задаче, как и в задаче №9, можно было бы записать большую часть решения,
т.е. поиск делителей и a - **перебором**, что легко реализовывается на
императивном языке вроде Python. Но в функциональном стиле нужно решить задачу с
использованием **рекурсии**, **функций высшего порядка** и различных методов, в
результате чего приходилось придумывать решения в зависимости от подхода.

#### Постановка задачи:

Нам нужно найти сумму всех **дружественных чисел** меньше $10000$. Два числа
считаются дружественными, если для них выполняется:

1. $d(a) = b$ — сумма собственных делителей $a$ равна $b$.
2. $d(b) = a$ — сумма собственных делителей $b$ равна $a$, при этом
   $a
   \neq b$.

#### Общий алгоритм решения:

1. **Функция для нахождения суммы делителей**:

   - Для каждого числа $n$ мы должны найти его собственные делители и вычислить
     их сумму.
   - Здесь мы можем использовать подход, где сумма делителей считается с
     использованием перебора до $\frac{n}{2}$, так как все делители $n$ меньше
     или равны половине числа $n$.

2. **Перебор чисел от 2 до 10000**:
   - Для каждого числа $a$ мы находим сумму его делителей $b = d(a)$.
   - Если $d(b) = a$ и $a \neq b$, то $a$ и $b$ — дружественная пара, и мы
     добавляем оба числа в список дружественных чисел.
3. **Рекурсивный подход**:
   - Для рекурсии мы можем написать функцию, которая будет последовательно
     увеличивать число $n$ от 2 до предела (в нашем случае $10000$), проверять
     условие дружественности и накапливать сумму дружественных чисел.

#### Рекурсивное решение:

Для рекурсивного решения мы можем разделить задачу на несколько частей:

1. **Основная функция `sum_amicable_numbers(limit)`**:

   - Она инициализирует процесс и вызывает рекурсивную функцию для каждого числа
     $n$ от 2 до предела $limit$.

2. **Рекурсивная функция `do_sum/3`**:

   - Эта функция принимает текущее число $n$, предел $limit$, и аккумулятор для
     накопления суммы дружественных чисел.
   - Если $n$ меньше предела, то:
     - Вычисляем сумму делителей $d(n)$.
     - Если $n$ и $d(n)$ образуют дружественную пару, добавляем $n$ в
       аккумулятор и продолжаем рекурсию для следующего числа $n + 1$.
   - Когда $n$ достигнет предела, рекурсия завершится и вернётся сумма всех
     дружественных чисел.

3. **Функция `sum_of_divisors(n)`**:
   - Она рекурсивно находит сумму собственных делителей числа $n$, перебирая
     числа от $\frac{n}{2}$ до 1 и проверяя, делится ли число $n$ на каждый
     делитель.

### Рекурсивное решение

```elixir
defmodule Euler21Recursion do
  @moduledoc """
  Module handling recursive implementations for Euler problem 21.
  """
  def sum_amicable_numbers(limit) do
    do_sum(2, limit, [])
  end

  defp do_sum(n, limit, acc) when n < limit do
    sum_div = sum_of_divisors(n)

    if sum_div != n and sum_of_divisors(sum_div) == n do
      do_sum(n + 1, limit, [n | acc])
    else
      do_sum(n + 1, limit, acc)
    end
  end

  defp do_sum(_, _, acc), do: Enum.sum(acc)

  defp sum_of_divisors(n), do: sum_of_divisors(n, div(n, 2), 0)

  defp sum_of_divisors(_, i, acc) when i <= 0, do: acc

  defp sum_of_divisors(n, i, acc) do
    if rem(n, i) == 0 do
      sum_of_divisors(n, i - 1, acc + i)
    else
      sum_of_divisors(n, i - 1, acc)
    end
  end
end
```

### Решение с хвостовой рекурсией

```elixir
defmodule Euler21TailRecursion do
  @moduledoc """
  Module handling tail-recursive implementations for Euler problem 21.
  """
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
```

### Модульная реализация (генерация, фильтрация, свёртка)

```elixir
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
    if n > 1 do
      1..div(n, 2)
      |> Enum.filter(&(rem(n, &1) == 0))
      |> Enum.sum()
    else
      0
    end
  end

  defp limit, do: 10_000
end
```

### Решение с использованием специального синтаксиса для циклов (Comprehensions)

```elixir
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
    if n > 1 do
      for(
        i <- 1..div(n, 2),
        rem(n, i) == 0,
        do: i
      )
      |> Enum.sum()
    else
      0
    end
  end

  defp limit, do: 10_000
end
```

### Бесконечные потоки чисел, ленивые коллекции

```elixir
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
    if n > 1 do
      1..div(n, 2)
      |> Enum.filter(&(rem(n, &1) == 0))
      |> Enum.sum()
    else
      0
    end
  end

  defp limit, do: 10_000
end
```

### Реализация на удобном императивном языке (Python)

```elixir
def sum_div(n):
    sum = 0
    for i in range(1, int(n**0.5) + 1):
        if n % i == 0:
            sum += i
            if i != 1 and i != n // i:
                sum += n // i
    return sum


def find_amicable_nums(limit):
    nums = set()
    for a in range(2, limit):
        b = sum_div(a)
        if a != b and sum_div(b) == a:
            nums.add(a)
            nums.add(b)
    return sum(nums)


limit = 10_000
print(f"Amicle numbers sum below {limit} is {find_amicable_nums(limit)}")
```

## Вывод

В ходе данной лабораторной работы я изучил значительную часть документации по
Elixir, познакомился с его типами данных и структурами. Я узнал о разнице между
`Stream` и `Enum` в контексте ленивых вычислений, а также познакомился с
концепцией бесконечных потоков. Меня приятно удивило, что в функциональном
программировании нет традиционных циклов `for`, и вместо них используются
рекурсии, свёртывание и другие концепции, что может показаться сложным на первый
взгляд, но на самом деле приемлемо после знакомства с различными способами
реализации, многие из которых мимикрируют под стандартные циклы императивных
языков. Я изучил условные операторы, структуру модулей и функций в Elixir, а
также основы синтаксиса, анонимные функции, кложуры и оператор захвата. Решая
задачи из проекта Эйлера, я открыл для себя, насколько удобен и эффективен
Elixir.

Особенно понравилась работа с пайпами и генераторами, а также удобство
объявления анонимных функций. Модульная структура языка оказалась интуитивной и
систематизированной, глоток свежего воздуха после питона и js(ts), на которых
пока работаю.

Прочитав первые 100 страниц книги "Elixir in Action", я вдохновился не только
языком, но и всей инфраструктурой Erlang + OTP. BEAM VM оказалась впечатляющей:
хотя в исходном коде встречаются "магические" числа и незадокументированные
участки, виртуальная машина работает гораздо лучше, чем интерпретаторы Python
или даже Java.

Хотел сделать code coverage, посидеть попрофилировать решения, но завяз на 100
часов за электротехникой, скажите студофису чтоб убрали 11 предметов блин.
