from testutils import assert_raises

try:
    b"   \xff".decode("ascii")
except UnicodeDecodeError as e:
    assert e.start == 3
    assert e.end == 4
else:
    assert False, "should have thrown UnicodeDecodeError"

assert_raises(UnicodeEncodeError, "ΒΏcomo estaΜs?".encode, "ascii")

def round_trip(s, encoding="utf-8"):
    encoded = s.encode(encoding)
    decoded = encoded.decode(encoding)
    assert s == decoded

round_trip("πΊβ¦  πΕΔΖ  ββ")
round_trip("β’π£  απ€πΡβππ₯εΟπ«  β¬π£")
round_trip("ππ  Χ§πtββπ· οΌ  π₯π€")
