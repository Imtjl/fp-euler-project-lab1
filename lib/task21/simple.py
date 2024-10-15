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
