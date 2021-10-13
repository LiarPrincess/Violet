'''
Instance of a standard Python type does not have a '__dict__'.
Instance of the subclass of that type has '__dict__'.

object().__dict__ # -> AttributeError

class MyObject(object): pass
MyObject().__dict__
'''

import builtins
import sys

# === Not tested ===

# cell
# TextFile

# === Basic ===

# object
try:
    o = object()
    o.__dict__
    assert False, 'object'
except AttributeError:
    pass


class MyObject(object):
    pass


o = MyObject()
o.__dict__

# type
int.__dict__

# NoneType
try:
    None.__dict__
    assert False, 'NoneType'
except AttributeError:
    pass

# ellipsis
try:
    (...).__dict__
    assert False, 'NoneType'
except AttributeError:
    pass

# NotImplementedType
try:
    NotImplemented.__dict__
    assert False, 'NoneType'
except AttributeError:
    pass

# types.SimpleNamespace
# Not done

# =================================
# === int, bool, float, complex ===
# =================================

# int
try:
    (1).__dict__
    assert False, 'int'
except AttributeError:
    pass


class MyInt(int):
    pass


i = MyInt()
i.__dict__

# bool
try:
    (True).__dict__
    assert False, 'bool'
except AttributeError:
    pass

try:
    (False).__dict__
    assert False, 'bool'
except AttributeError:
    pass

# float
try:
    (1.42).__dict__
    assert False, 'float'
except AttributeError:
    pass


class MyFloat(float):
    pass


f = MyFloat()
f.__dict__

# complex
try:
    (1.42j).__dict__
    assert False, 'complex'
except AttributeError:
    pass


class MyComplex(complex):
    pass


c = MyComplex()
c.__dict__

# ===================
# === list, tuple ===
# ===================

# list
try:
    [].__dict__
    assert False, 'list'
except AttributeError:
    pass


class MyList(list):
    pass


l = MyList()
l.__dict__

# list_iterator
try:
    [].__iter__.__dict__
    assert False, 'list_iterator'
except AttributeError:
    pass

# list_reverseiterator
try:
    [].__reversed__.__dict__
    assert False, 'list_reverseiterator'
except AttributeError:
    pass

# tuple
try:
    ().__dict__
    assert False, 'tuple'
except AttributeError:
    pass


class MyTuple(tuple):
    pass


t = MyTuple()
t.__dict__

# tuple_iterator
try:
    ().__iter__.__dict__
    assert False, 'tuple_iterator'
except AttributeError:
    pass

# =============================
# === str, bytes, bytearray ===
# =============================

# str
try:
    ''.__dict__
    assert False, 'str'
except AttributeError:
    pass


class MyStr(str):
    pass


s = MyStr()
s.__dict__


# str_iterator
try:
    ''.__iter__.__dict__
    assert False, 'str_iterator'
except AttributeError:
    pass

# bytes
try:
    b''.__dict__
    assert False, 'bytes'
except AttributeError:
    pass


class MyBytes(bytes):
    pass


s = MyBytes()
s.__dict__

# bytes_iterator
try:
    b''.__iter__.__dict__
    assert False, 'bytes_iterator'
except AttributeError:
    pass

# bytearray
try:
    bytearray().__dict__
    assert False, 'bytearray'
except AttributeError:
    pass


class MyByteArray(bytearray):
    pass


s = MyByteArray()
s.__dict__

# bytearray_iterator
try:
    bytearray().__iter__.__dict__
    assert False, 'bytes_iterator'
except AttributeError:
    pass

# ============
# === dict ===
# ============

# dict
try:
    dict().__dict__
    assert False, 'dict'
except AttributeError:
    pass


class MyDict(dict):
    pass


d = MyDict()
d.__dict__


# dict_items
try:
    dict().items().__dict__
    assert False, 'dict_items'
except AttributeError:
    pass

# dict_itemiterator
try:
    dict().items().__iter__.__dict__
    assert False, 'dict_itemiterator'
except AttributeError:
    pass

# dict_keys
try:
    dict().keys().__dict__
    assert False, 'dict_keys'
except AttributeError:
    pass

# dict_keyiterator
try:
    dict().keys().__iter__.__dict__
    assert False, 'dict_keyiterator'
except AttributeError:
    pass

# dict_values
try:
    dict().values().__iter__.__dict__
    assert False, 'dict_values'
except AttributeError:
    pass

# dict_valueiterator
try:
    dict().values().__dict__
    assert False, 'dict_valueiterator'
except AttributeError:
    pass

# ======================
# === set, frozenset ===
# ======================

# set
try:
    set().__dict__
    assert False, 'set'
except AttributeError:
    pass


class MySet(set):
    pass


s = MySet()
s.__dict__

# frozenset
try:
    frozenset().__dict__
    assert False, 'frozenset'
except AttributeError:
    pass


class MyFrozenSet(frozenset):
    pass


s = MyFrozenSet()
s.__dict__

# set_iterator
try:
    set().__iter__.__dict__
    assert False, 'set_iterator'
except AttributeError:
    pass


# === range, slice ===

try:
    range(5).__dict__
    assert False, 'range'
except AttributeError:
    pass

try:
    range(5).__iter__.__dict__
    assert False, 'range_iterator'
except AttributeError:
    pass

try:
    l = [1, 2, 3]
    l[1:2].__dict__
    assert False, 'slice'
except AttributeError:
    pass


# === map, filter, zip, enumerate ===

# You had one job!
def fn_that_returns_true(i): return False


try:
    o = map(fn_that_returns_true, [1, 2, 3])
    o.__dict__
    assert False, 'map'
except AttributeError:
    pass

try:
    o = filter(fn_that_returns_true, [1, 2, 3])
    o.__dict__
    assert False, 'filter'
except AttributeError:
    pass

try:
    o = zip((1, 2, 3), [1, 2, 3])
    o.__dict__
    assert False, 'zip'
except AttributeError:
    pass

try:
    o = enumerate([1, 2, 3])
    o.__dict__
    assert False, 'enumerate'
except AttributeError:
    pass


# === iterator, reversed, callable_iterator ===

class DummyIterable:
    """
    We need a new class, if we used tuple/array that would return the type-specific '__iter__'.
    """

    def __len__(self): return 1
    def __getitem__(self): return 1


# iterator
try:
    o = iter(DummyIterable())
    o.__dict__
    assert False, 'iterator'
except AttributeError:
    pass


# reversed
try:
    o = reversed(DummyIterable())
    o.__dict__
    assert False, 'reversed'
except AttributeError:
    pass


# callable_iterator
def iter_fn_that_returns_1():
    return 1


try:
    sentinel_that_is_not_1 = 2
    o = iter(iter_fn_that_returns_1, sentinel_that_is_not_1)
    o.__dict__
    assert False, 'callable_iterator'
except AttributeError:
    pass


# === builtin function/method ===

try:
    iter.__dict__
    assert False, 'builtinFunction'
except AttributeError:
    pass

try:
    # We can't just use 'str.count',
    # we have to bind it to specific instance
    method = ''.count
    method.__dict__
    assert False, 'builtinMethod'
except AttributeError:
    pass


# === function, method, classmethod, staticmethod ===

def dummy_fn(): pass


dummy_fn.__dict__


class DummyClass:
    def method(self): pass


# We can't just use 'DummyClass.method',
# we have to bind it to specific instance
c = DummyClass()
method = c.method
method.__dict__

# We can't use ' @classmethod DummyClass.class_method',
# because then getter ('DummyClass.class_method' thingy)
# would bind it to 'cls' ('DummyClass') creating 'method'.
class_method = classmethod(dummy_fn)
class_method.__dict__

# While we could use '@staticmethod' inside 'DummyClass',
# we will just use '__init__' for symmetry with 'classmethod'.
static_method_ = staticmethod(dummy_fn)
static_method_.__dict__


# === property ===

class DummyClass:
    @property
    def x(self): return 1


# Test it, because I never remember the syntax
c = DummyClass()
assert c.x == 1

try:
    DummyClass.x.__dict__
    assert False, 'property'
except AttributeError:
    pass


# === code, frame, module, super, traceback ===

def dummy_fn(): pass


class DummyClass:
    pass


# code
try:
    dummy_fn.__code__.__dict__
    assert False, 'code'
except AttributeError:
    pass

# frame
try:
    f = sys._getframe
    f.__dict__
    assert False, 'frame'
except AttributeError:
    pass

# module
builtins.__dict__

# super
try:
    s = super(int)
    s.__dict__
    assert False, 'super'
except AttributeError:
    pass


# traceback

def give_me_traceback():
    try:
        raise ValueError('dummy')
    except ValueError as e:
        return e.__traceback__


try:
    tb = give_me_traceback()
    tb.__dict__
    assert False, 'traceback'
except AttributeError:
    pass

# === Errors ===

BaseException('').__dict__
SystemExit('').__dict__
KeyboardInterrupt('').__dict__
GeneratorExit('').__dict__
Exception('').__dict__
StopIteration('').__dict__
StopAsyncIteration('').__dict__
ArithmeticError('').__dict__
FloatingPointError('').__dict__
OverflowError('').__dict__
ZeroDivisionError('').__dict__
AssertionError('').__dict__
AttributeError('').__dict__
BufferError('').__dict__
EOFError('').__dict__
ImportError('').__dict__
ModuleNotFoundError('').__dict__
LookupError('').__dict__
IndexError('').__dict__
KeyError('').__dict__
MemoryError('').__dict__
NameError('').__dict__
UnboundLocalError('').__dict__
OSError('').__dict__
BlockingIOError('').__dict__
ChildProcessError('').__dict__
ConnectionError('').__dict__
BrokenPipeError('').__dict__
ConnectionAbortedError('').__dict__
ConnectionRefusedError('').__dict__
ConnectionResetError('').__dict__
FileExistsError('').__dict__
FileNotFoundError('').__dict__
InterruptedError('').__dict__
IsADirectoryError('').__dict__
NotADirectoryError('').__dict__
PermissionError('').__dict__
ProcessLookupError('').__dict__
TimeoutError('').__dict__
ReferenceError('').__dict__
RuntimeError('').__dict__
NotImplementedError('').__dict__
RecursionError('').__dict__
SyntaxError('').__dict__
IndentationError('').__dict__
TabError('').__dict__
SystemError('').__dict__
TypeError('').__dict__
ValueError('').__dict__
UnicodeError('').__dict__
UnicodeDecodeError('ascii', b'', 0, 1, '?').__dict__
UnicodeEncodeError('ascii', '', 0, 1, '?').__dict__
UnicodeTranslateError('ascii', 0, 1, '?').__dict__
Warning('').__dict__
DeprecationWarning('').__dict__
PendingDeprecationWarning('').__dict__
RuntimeWarning('').__dict__
SyntaxWarning('').__dict__
UserWarning('').__dict__
FutureWarning('').__dict__
ImportWarning('').__dict__
UnicodeWarning('').__dict__
BytesWarning('').__dict__
ResourceWarning('').__dict__
