# def ret(expression):
#     return expression

ret = "0" if True else "1"
assert ret == "0"
ret = "0" if False else "1"
assert ret == "1"

ret = "0" if False else ("1" if True else "2")
assert ret == "1"
ret = "0" if False else ("1" if False else "2")
assert ret == "2"

ret = ("0" if True else "1") if True else "2"
assert ret == "0"
ret = ("0" if False else "1") if True else "2"
assert ret == "1"

a = True
b = False
ret = "0" if a or b else "1"
assert ret == "0"
ret = "0" if a and b else "1"
assert ret == "1"

# def func1():
#     return 0

# def func2():
#     return 20

# assert ret(func1() or func2()) == 20
