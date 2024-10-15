def find_pyth_triplet(sum_):
    for a in range(1, sum_):
        for b in range(1, sum_):
            c = 1000 - a - b
            if a**2 + b**2 == c**2:
                return a, b, c


a, b, c = find_pyth_triplet(1000)
print(f"Pythagorean triplet: a = {a}. b = {b}, c = {c}")
print(f"Product abc = {a * b * c}")
