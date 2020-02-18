recursive_list = []
recursive = (recursive_list,)
recursive_list.append(recursive)
assert repr(recursive) == "([(...)],)"

assert (None, "", 1).index(1) == 2
assert 1 in (None, "", 1)

# class Foo(object):
#     def __eq__(self, x):
#         return False

# foo = Foo()
# assert (foo,) == (foo,)

a = (1, 2, 3)
a += 1,
assert a == (1, 2, 3, 1)

b = (55, *a)
assert b == (55, 1, 2, 3, 1)
