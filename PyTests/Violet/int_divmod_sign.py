a = 7
b = 3
result = a.__divmod__(b)
assert result[0] == 2
assert result[1] == 1

a = -7
b = 3
result = a.__divmod__(b)
assert result[0] == -3
assert result[1] == 2

a = 7
b = -3
result = a.__divmod__(b)
assert result[0] == -3
assert result[1] == -2

a = -7
b = -3
result = a.__divmod__(b)
assert result[0] == 2
assert result[1] == -1
