assert (1).__add__(2) == 3
assert int.__add__(1, 2) == 3
assert type(1).__add__(1, 2) == 3

try:
    raise BaseException()
except BaseException as ex:
    print(type(ex))
