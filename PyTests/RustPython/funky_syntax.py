# VIOLET: We do not have 'traceback' module
# import traceback

a = 2
b = 2 + 4 if a < 5 else 'boe'
assert b == 6
c = 2 + 4 if a > 5 else 'boe'
assert c == 'boe'

d = lambda x, y: x > y
assert d(5, 4)

e = lambda x: 1 if x else 0
assert e(True) == 1
assert e(False) == 0

try:
	a = "aaaa" + \
		"bbbb"
	1/0
except ZeroDivisionError as ex:
	# VIOLET: We do not have 'traceback' module, also due to our comments we had to change 19 -> 20 as line number
	# tb = traceback.extract_tb(ex.__traceback__)
	# assert tb[0].lineno == 19
	tb = ex.__traceback__
	assert tb.tb_lineno == 20
