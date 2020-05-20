class MyInt(int):
  pass

i = MyInt(7)
i.x = 5

assert i.x == 5
assert getattr(i, 'x') == 5

del i.x
assert not hasattr(i, 'x')

error_a = AttributeError('a')
error_b = AttributeError('b')

# ===========================
# == NoAttributeResolution ==
# ===========================

class NoAttributeResolution:
  pass

obj = NoAttributeResolution()
try:
  obj.elsa
  assert False
except AttributeError:
  pass

# ==================
# == GetAttribute ==
# ==================

class GetAttribute:
  def __getattribute__(self, attr): return 'elsa'

obj = GetAttribute()
assert obj.elsa == 'elsa'
assert getattr(obj, 'elsa') == 'elsa'
assert hasattr(obj, 'elsa')

class GetAttributeRaises:
  def __getattribute__(self, attr): raise error_a

obj = GetAttributeRaises()
try:
  obj.elsa
  assert False
except BaseException as hopefully_a:
  assert hopefully_a == error_a

# =============
# == GetAttr ==
# =============

class GetAttr:
  def __getattribute__(self, attr): raise error_a
  def __getattr__(self, attr): return 'elsa'

obj = GetAttribute()
assert obj.elsa == 'elsa'
assert getattr(obj, 'elsa') == 'elsa'
assert hasattr(obj, 'elsa')

class GetAttrRaises:
  def __getattribute__(self, attr): raise error_a
  def __getattr__(self, attr): raise error_b

obj = GetAttrRaises()
try:
  obj.elsa
  assert False
except BaseException as hopefully_b:
  assert hopefully_b == error_b
