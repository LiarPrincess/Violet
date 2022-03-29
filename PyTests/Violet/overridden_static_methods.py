# ==================================================================================================
# Automatically generated from: ./PyTests/Violet/generate_overridden_static_methods_test/__main__.py
# DO NOT EDIT!
# ==================================================================================================

'''
We sometimes dispatch methods using 'object.type.staticMethods' instead of doing
a standard Python dispatch. But if we override given method in subtype then we
should always use dynamic dispatch. This file will test just that.

See 'PyStaticCall' documentation for more information.
'''

import sys

# Not all of the types are in 'builtins'.
if sys.implementation.name == 'Violet':
    module = type(sys)
    SimpleNamespace = type(sys.implementation)
else:
    from types import SimpleNamespace
    from types import ModuleType as module

# ===============
# === Globals ===
# ===============

# Insert value to this dictionary to indicate that the method was called.
global_values = {}


def set_global_value(class_name: object, method_name: str):
    global global_values
    key = class_name + '.' + method_name
    global_values[key] = True


def is_global_value_set(class_name: object, method_name: str):
    global global_values
    key = class_name + '.' + method_name
    return global_values.get(key)


# Commonly used values.
attribute_name = 'attribute_name'
index_value = 1234
hash_value = 42
dir_value = ['__dir__']

# =================
# === bytearray ===
# =================

class MyBytearray(bytearray):

    def __repr__(self):
        return '__repr__'

    def __str__(self):
        return '__str__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyBytearray', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __getitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyBytearray', '__getitem__')
            return None
        return super().__getitem__(index)

    def __setitem__(self, index, value):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyBytearray', '__setitem__')
            return None
        return super().__setitem__(index, value)

    def __delitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyBytearray', '__delitem__')
            return None
        return super().__delitem__(index)

    def __iter__(self):
        global set_global_value
        set_global_value('MyBytearray', '__iter__')
        return super().__iter__()

    def __len__(self):
        global set_global_value
        set_global_value('MyBytearray', '__len__')
        return 1

    def __contains__(self, element):
        global set_global_value
        set_global_value('MyBytearray', '__contains__')
        return False

    def __add__(self, o):
        return '__add__'

    def __mul__(self, o):
        return '__mul__'

    def __rmul__(self, o):
        return '__rmul__'

    def __iadd__(self, o):
        return '__iadd__'

    def __imul__(self, o):
        return '__imul__'


o = MyBytearray()
assert repr(o) == '__repr__'
assert str(o) == '__str__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MyBytearray', '__getattribute__')
o[index_value]
assert is_global_value_set('MyBytearray', '__getitem__')
o[index_value] = 43
assert is_global_value_set('MyBytearray', '__setitem__')
del o[index_value]
assert is_global_value_set('MyBytearray', '__delitem__')
iter(o)
assert is_global_value_set('MyBytearray', '__iter__')
len(o)
assert is_global_value_set('MyBytearray', '__len__')
42 in o
assert is_global_value_set('MyBytearray', '__contains__')
assert o.__add__(bytearray()) == '__add__'
assert o + bytearray() == '__add__'
assert o.__mul__(bytearray()) == '__mul__'
assert o * bytearray() == '__mul__'
assert o.__rmul__(bytearray()) == '__rmul__'
assert bytearray() * o == '__rmul__'
assert o.__iadd__(bytearray()) == '__iadd__'
o_copy = o
o_copy += bytearray()
assert o_copy == '__iadd__'
assert o.__imul__(bytearray()) == '__imul__'
o_copy = o
o_copy *= bytearray()
assert o_copy == '__imul__'

# =============
# === bytes ===
# =============

class MyBytes(bytes):

    def __repr__(self):
        return '__repr__'

    def __str__(self):
        return '__str__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyBytes', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __getitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyBytes', '__getitem__')
            return None
        return super().__getitem__(index)

    def __iter__(self):
        global set_global_value
        set_global_value('MyBytes', '__iter__')
        return super().__iter__()

    def __len__(self):
        global set_global_value
        set_global_value('MyBytes', '__len__')
        return 1

    def __contains__(self, element):
        global set_global_value
        set_global_value('MyBytes', '__contains__')
        return False

    def __add__(self, o):
        return '__add__'

    def __mul__(self, o):
        return '__mul__'

    def __rmul__(self, o):
        return '__rmul__'


o = MyBytes()
assert repr(o) == '__repr__'
assert str(o) == '__str__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MyBytes', '__getattribute__')
o[index_value]
assert is_global_value_set('MyBytes', '__getitem__')
iter(o)
assert is_global_value_set('MyBytes', '__iter__')
len(o)
assert is_global_value_set('MyBytes', '__len__')
42 in o
assert is_global_value_set('MyBytes', '__contains__')
assert o.__add__(b'') == '__add__'
assert o + b'' == '__add__'
assert o.__mul__(b'') == '__mul__'
assert o * b'' == '__mul__'
assert o.__rmul__(b'') == '__rmul__'
assert b'' * o == '__rmul__'

# ===================
# === classmethod ===
# ===================

class MyClassmethod(classmethod):

    def __isabstractmethod__(self):
        global set_global_value
        set_global_value('MyClassmethod', '__isabstractmethod__')
        return False


o = MyClassmethod(lambda: None)
o.__isabstractmethod__()
assert is_global_value_set('MyClassmethod', '__isabstractmethod__')

# ===============
# === complex ===
# ===============

class MyComplex(complex):

    def __repr__(self):
        return '__repr__'

    def __str__(self):
        return '__str__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __bool__(self):
        global set_global_value
        set_global_value('MyComplex', '__bool__')
        return False

    def __int__(self):
        global set_global_value
        set_global_value('MyComplex', '__int__')
        return 42

    def __float__(self):
        global set_global_value
        set_global_value('MyComplex', '__float__')
        return 42.3

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyComplex', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __pos__(self):
        return '__pos__'

    def __neg__(self):
        return '__neg__'

    def __abs__(self):
        return '__abs__'

    def __add__(self, o):
        return '__add__'

    def __divmod__(self, o):
        return '__divmod__'

    def __floordiv__(self, o):
        return '__floordiv__'

    def __mod__(self, o):
        return '__mod__'

    def __mul__(self, o):
        return '__mul__'

    def __sub__(self, o):
        return '__sub__'

    def __truediv__(self, o):
        return '__truediv__'

    def __radd__(self, o):
        return '__radd__'

    def __rdivmod__(self, o):
        return '__rdivmod__'

    def __rfloordiv__(self, o):
        return '__rfloordiv__'

    def __rmod__(self, o):
        return '__rmod__'

    def __rmul__(self, o):
        return '__rmul__'

    def __rsub__(self, o):
        return '__rsub__'

    def __rtruediv__(self, o):
        return '__rtruediv__'

    def __pow__(self, o, mod=None):
        return '__pow__'

    def __rpow__(self, o, mod=None):
        return '__rpow__'


o = MyComplex()
assert repr(o) == '__repr__'
assert str(o) == '__str__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
bool(o)
assert is_global_value_set('MyComplex', '__bool__')
int(o)
assert is_global_value_set('MyComplex', '__int__')
float(o)
assert is_global_value_set('MyComplex', '__float__')
getattr(o, attribute_name)
assert is_global_value_set('MyComplex', '__getattribute__')
assert o.__pos__() == '__pos__'
assert (+o) == '__pos__'
assert o.__neg__() == '__neg__'
assert (-o) == '__neg__'
assert o.__abs__() == '__abs__'
assert abs(o) == '__abs__'
assert o.__add__(1.0j) == '__add__'
assert o + 1.0j == '__add__'
assert o.__divmod__(1.0j) == '__divmod__'
assert o.__floordiv__(1.0j) == '__floordiv__'
assert o.__mod__(1.0j) == '__mod__'
assert o % 1.0j == '__mod__'
assert o.__mul__(1.0j) == '__mul__'
assert o * 1.0j == '__mul__'
assert o.__sub__(1.0j) == '__sub__'
assert o - 1.0j == '__sub__'
assert o.__truediv__(1.0j) == '__truediv__'
assert o / 1.0j == '__truediv__'
assert o.__radd__(1.0j) == '__radd__'
assert 1.0j + o == '__radd__'
assert o.__rdivmod__(1.0j) == '__rdivmod__'
assert o.__rfloordiv__(1.0j) == '__rfloordiv__'
assert o.__rmod__(1.0j) == '__rmod__'
assert 1.0j % o == '__rmod__'
assert o.__rmul__(1.0j) == '__rmul__'
assert 1.0j * o == '__rmul__'
assert o.__rsub__(1.0j) == '__rsub__'
assert 1.0j - o == '__rsub__'
assert o.__rtruediv__(1.0j) == '__rtruediv__'
assert 1.0j / o == '__rtruediv__'
assert o.__pow__(1.0j) == '__pow__'
assert pow(o, 1.0j) == '__pow__'
assert o.__rpow__(1.0j) == '__rpow__'
assert pow(1.0j, o) == '__rpow__'

# ============
# === dict ===
# ============

class MyDict(dict):

    def __repr__(self):
        return '__repr__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyDict', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __getitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyDict', '__getitem__')
            return None
        return super().__getitem__(index)

    def __setitem__(self, index, value):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyDict', '__setitem__')
            return None
        return super().__setitem__(index, value)

    def __delitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyDict', '__delitem__')
            return None
        return super().__delitem__(index)

    def __iter__(self):
        global set_global_value
        set_global_value('MyDict', '__iter__')
        return super().__iter__()

    def __len__(self):
        global set_global_value
        set_global_value('MyDict', '__len__')
        return 1

    def __contains__(self, element):
        global set_global_value
        set_global_value('MyDict', '__contains__')
        return False

    def keys(self):
        global set_global_value
        set_global_value('MyDict', 'keys')
        return super().keys()


o = MyDict()
assert repr(o) == '__repr__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MyDict', '__getattribute__')
o[index_value]
assert is_global_value_set('MyDict', '__getitem__')
o[index_value] = 43
assert is_global_value_set('MyDict', '__setitem__')
del o[index_value]
assert is_global_value_set('MyDict', '__delitem__')
iter(o)
assert is_global_value_set('MyDict', '__iter__')
len(o)
assert is_global_value_set('MyDict', '__len__')
42 in o
assert is_global_value_set('MyDict', '__contains__')
o.keys()
assert is_global_value_set('MyDict', 'keys')

# =================
# === enumerate ===
# =================

class MyEnumerate(enumerate):

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyEnumerate', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __iter__(self):
        global set_global_value
        set_global_value('MyEnumerate', '__iter__')
        return super().__iter__()

    def __next__(self):
        global set_global_value
        set_global_value('MyEnumerate', '__next__')
        return 'infinite loop'


o = MyEnumerate([])
getattr(o, attribute_name)
assert is_global_value_set('MyEnumerate', '__getattribute__')
iter(o)
assert is_global_value_set('MyEnumerate', '__iter__')
next(o)
assert is_global_value_set('MyEnumerate', '__next__')

# ==============
# === filter ===
# ==============

class MyFilter(filter):

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyFilter', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __iter__(self):
        global set_global_value
        set_global_value('MyFilter', '__iter__')
        return super().__iter__()

    def __next__(self):
        global set_global_value
        set_global_value('MyFilter', '__next__')
        return 'infinite loop'


o = MyFilter(lambda: None, [])
getattr(o, attribute_name)
assert is_global_value_set('MyFilter', '__getattribute__')
iter(o)
assert is_global_value_set('MyFilter', '__iter__')
next(o)
assert is_global_value_set('MyFilter', '__next__')

# =============
# === float ===
# =============

class MyFloat(float):

    def __repr__(self):
        return '__repr__'

    def __str__(self):
        return '__str__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __bool__(self):
        global set_global_value
        set_global_value('MyFloat', '__bool__')
        return False

    def __int__(self):
        global set_global_value
        set_global_value('MyFloat', '__int__')
        return 42

    def __float__(self):
        global set_global_value
        set_global_value('MyFloat', '__float__')
        return 42.3

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyFloat', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __pos__(self):
        return '__pos__'

    def __neg__(self):
        return '__neg__'

    def __abs__(self):
        return '__abs__'

    def __trunc__(self):
        return '__trunc__'

    def __round__(self, ndigits = None):
        return '__round__'

    def __add__(self, o):
        return '__add__'

    def __divmod__(self, o):
        return '__divmod__'

    def __floordiv__(self, o):
        return '__floordiv__'

    def __mod__(self, o):
        return '__mod__'

    def __mul__(self, o):
        return '__mul__'

    def __sub__(self, o):
        return '__sub__'

    def __truediv__(self, o):
        return '__truediv__'

    def __radd__(self, o):
        return '__radd__'

    def __rdivmod__(self, o):
        return '__rdivmod__'

    def __rfloordiv__(self, o):
        return '__rfloordiv__'

    def __rmod__(self, o):
        return '__rmod__'

    def __rmul__(self, o):
        return '__rmul__'

    def __rsub__(self, o):
        return '__rsub__'

    def __rtruediv__(self, o):
        return '__rtruediv__'

    def __pow__(self, o, mod=None):
        return '__pow__'

    def __rpow__(self, o, mod=None):
        return '__rpow__'


o = MyFloat()
assert repr(o) == '__repr__'
assert str(o) == '__str__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
bool(o)
assert is_global_value_set('MyFloat', '__bool__')
int(o)
assert is_global_value_set('MyFloat', '__int__')
float(o)
assert is_global_value_set('MyFloat', '__float__')
getattr(o, attribute_name)
assert is_global_value_set('MyFloat', '__getattribute__')
assert o.__pos__() == '__pos__'
assert (+o) == '__pos__'
assert o.__neg__() == '__neg__'
assert (-o) == '__neg__'
assert o.__abs__() == '__abs__'
assert abs(o) == '__abs__'
assert o.__trunc__() == '__trunc__'
assert round(o) == '__round__'
assert o.__add__(1.0) == '__add__'
assert o + 1.0 == '__add__'
assert o.__divmod__(1.0) == '__divmod__'
assert o.__floordiv__(1.0) == '__floordiv__'
assert o.__mod__(1.0) == '__mod__'
assert o % 1.0 == '__mod__'
assert o.__mul__(1.0) == '__mul__'
assert o * 1.0 == '__mul__'
assert o.__sub__(1.0) == '__sub__'
assert o - 1.0 == '__sub__'
assert o.__truediv__(1.0) == '__truediv__'
assert o / 1.0 == '__truediv__'
assert o.__radd__(1.0) == '__radd__'
assert 1.0 + o == '__radd__'
assert o.__rdivmod__(1.0) == '__rdivmod__'
assert o.__rfloordiv__(1.0) == '__rfloordiv__'
assert o.__rmod__(1.0) == '__rmod__'
assert 1.0 % o == '__rmod__'
assert o.__rmul__(1.0) == '__rmul__'
assert 1.0 * o == '__rmul__'
assert o.__rsub__(1.0) == '__rsub__'
assert 1.0 - o == '__rsub__'
assert o.__rtruediv__(1.0) == '__rtruediv__'
assert 1.0 / o == '__rtruediv__'
assert o.__pow__(1.0) == '__pow__'
assert pow(o, 1.0) == '__pow__'
assert o.__rpow__(1.0) == '__rpow__'
assert pow(1.0, o) == '__rpow__'

# =================
# === frozenset ===
# =================

class MyFrozenset(frozenset):

    def __repr__(self):
        return '__repr__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyFrozenset', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __iter__(self):
        global set_global_value
        set_global_value('MyFrozenset', '__iter__')
        return super().__iter__()

    def __len__(self):
        global set_global_value
        set_global_value('MyFrozenset', '__len__')
        return 1

    def __contains__(self, element):
        global set_global_value
        set_global_value('MyFrozenset', '__contains__')
        return False

    def __and__(self, o):
        return '__and__'

    def __or__(self, o):
        return '__or__'

    def __sub__(self, o):
        return '__sub__'

    def __xor__(self, o):
        return '__xor__'

    def __rand__(self, o):
        return '__rand__'

    def __ror__(self, o):
        return '__ror__'

    def __rsub__(self, o):
        return '__rsub__'

    def __rxor__(self, o):
        return '__rxor__'


o = MyFrozenset()
assert repr(o) == '__repr__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MyFrozenset', '__getattribute__')
iter(o)
assert is_global_value_set('MyFrozenset', '__iter__')
len(o)
assert is_global_value_set('MyFrozenset', '__len__')
42 in o
assert is_global_value_set('MyFrozenset', '__contains__')
assert o.__and__(frozenset()) == '__and__'
assert o & frozenset() == '__and__'
assert o.__or__(frozenset()) == '__or__'
assert o | frozenset() == '__or__'
assert o.__sub__(frozenset()) == '__sub__'
assert o - frozenset() == '__sub__'
assert o.__xor__(frozenset()) == '__xor__'
assert o ^ frozenset() == '__xor__'
assert o.__rand__(frozenset()) == '__rand__'
assert frozenset() & o == '__rand__'
assert o.__ror__(frozenset()) == '__ror__'
assert frozenset() | o == '__ror__'
assert o.__rsub__(frozenset()) == '__rsub__'
assert frozenset() - o == '__rsub__'
assert o.__rxor__(frozenset()) == '__rxor__'
assert frozenset() ^ o == '__rxor__'

# ===========
# === int ===
# ===========

class MyInt(int):

    def __repr__(self):
        return '__repr__'

    def __str__(self):
        return '__str__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __bool__(self):
        global set_global_value
        set_global_value('MyInt', '__bool__')
        return False

    def __int__(self):
        global set_global_value
        set_global_value('MyInt', '__int__')
        return 42

    def __float__(self):
        global set_global_value
        set_global_value('MyInt', '__float__')
        return 42.3

    def __index__(self):
        global set_global_value
        set_global_value('MyInt', '__index__')
        return 42

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyInt', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __pos__(self):
        return '__pos__'

    def __neg__(self):
        return '__neg__'

    def __invert__(self):
        return '__invert__'

    def __abs__(self):
        return '__abs__'

    def __trunc__(self):
        return '__trunc__'

    def __round__(self, ndigits = None):
        return '__round__'

    def __add__(self, o):
        return '__add__'

    def __and__(self, o):
        return '__and__'

    def __divmod__(self, o):
        return '__divmod__'

    def __floordiv__(self, o):
        return '__floordiv__'

    def __lshift__(self, o):
        return '__lshift__'

    def __mod__(self, o):
        return '__mod__'

    def __mul__(self, o):
        return '__mul__'

    def __or__(self, o):
        return '__or__'

    def __rshift__(self, o):
        return '__rshift__'

    def __sub__(self, o):
        return '__sub__'

    def __truediv__(self, o):
        return '__truediv__'

    def __xor__(self, o):
        return '__xor__'

    def __radd__(self, o):
        return '__radd__'

    def __rand__(self, o):
        return '__rand__'

    def __rdivmod__(self, o):
        return '__rdivmod__'

    def __rfloordiv__(self, o):
        return '__rfloordiv__'

    def __rlshift__(self, o):
        return '__rlshift__'

    def __rmod__(self, o):
        return '__rmod__'

    def __rmul__(self, o):
        return '__rmul__'

    def __ror__(self, o):
        return '__ror__'

    def __rrshift__(self, o):
        return '__rrshift__'

    def __rsub__(self, o):
        return '__rsub__'

    def __rtruediv__(self, o):
        return '__rtruediv__'

    def __rxor__(self, o):
        return '__rxor__'

    def __pow__(self, o, mod=None):
        return '__pow__'

    def __rpow__(self, o, mod=None):
        return '__rpow__'


o = MyInt()
assert repr(o) == '__repr__'
assert str(o) == '__str__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
bool(o)
assert is_global_value_set('MyInt', '__bool__')
int(o)
assert is_global_value_set('MyInt', '__int__')
float(o)
assert is_global_value_set('MyInt', '__float__')
o.__index__()
assert is_global_value_set('MyInt', '__index__')
getattr(o, attribute_name)
assert is_global_value_set('MyInt', '__getattribute__')
assert o.__pos__() == '__pos__'
assert (+o) == '__pos__'
assert o.__neg__() == '__neg__'
assert (-o) == '__neg__'
assert o.__invert__() == '__invert__'
assert (~o) == '__invert__'
assert o.__abs__() == '__abs__'
assert abs(o) == '__abs__'
assert o.__trunc__() == '__trunc__'
assert round(o) == '__round__'
assert o.__add__(1) == '__add__'
assert o + 1 == '__add__'
assert o.__and__(1) == '__and__'
assert o & 1 == '__and__'
assert o.__divmod__(1) == '__divmod__'
assert o.__floordiv__(1) == '__floordiv__'
assert o.__lshift__(1) == '__lshift__'
assert o << 1 == '__lshift__'
assert o.__mod__(1) == '__mod__'
assert o % 1 == '__mod__'
assert o.__mul__(1) == '__mul__'
assert o * 1 == '__mul__'
assert o.__or__(1) == '__or__'
assert o | 1 == '__or__'
assert o.__rshift__(1) == '__rshift__'
assert o >> 1 == '__rshift__'
assert o.__sub__(1) == '__sub__'
assert o - 1 == '__sub__'
assert o.__truediv__(1) == '__truediv__'
assert o / 1 == '__truediv__'
assert o.__xor__(1) == '__xor__'
assert o ^ 1 == '__xor__'
assert o.__radd__(1) == '__radd__'
assert 1 + o == '__radd__'
assert o.__rand__(1) == '__rand__'
assert 1 & o == '__rand__'
assert o.__rdivmod__(1) == '__rdivmod__'
assert o.__rfloordiv__(1) == '__rfloordiv__'
assert o.__rlshift__(1) == '__rlshift__'
assert 1 << o == '__rlshift__'
assert o.__rmod__(1) == '__rmod__'
assert 1 % o == '__rmod__'
assert o.__rmul__(1) == '__rmul__'
assert 1 * o == '__rmul__'
assert o.__ror__(1) == '__ror__'
assert 1 | o == '__ror__'
assert o.__rrshift__(1) == '__rrshift__'
assert 1 >> o == '__rrshift__'
assert o.__rsub__(1) == '__rsub__'
assert 1 - o == '__rsub__'
assert o.__rtruediv__(1) == '__rtruediv__'
assert 1 / o == '__rtruediv__'
assert o.__rxor__(1) == '__rxor__'
assert 1 ^ o == '__rxor__'
assert o.__pow__(1) == '__pow__'
assert pow(o, 1) == '__pow__'
assert o.__rpow__(1) == '__rpow__'
assert pow(1, o) == '__rpow__'

# ============
# === list ===
# ============

class MyList(list):

    def __repr__(self):
        return '__repr__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyList', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __getitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyList', '__getitem__')
            return None
        return super().__getitem__(index)

    def __setitem__(self, index, value):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyList', '__setitem__')
            return None
        return super().__setitem__(index, value)

    def __delitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyList', '__delitem__')
            return None
        return super().__delitem__(index)

    def __iter__(self):
        global set_global_value
        set_global_value('MyList', '__iter__')
        return super().__iter__()

    def __len__(self):
        global set_global_value
        set_global_value('MyList', '__len__')
        return 1

    def __contains__(self, element):
        global set_global_value
        set_global_value('MyList', '__contains__')
        return False

    def __reversed__(self):
        global set_global_value
        set_global_value('MyList', '__reversed__')
        return super().__reversed__()

    def __add__(self, o):
        return '__add__'

    def __mul__(self, o):
        return '__mul__'

    def __rmul__(self, o):
        return '__rmul__'

    def __iadd__(self, o):
        return '__iadd__'

    def __imul__(self, o):
        return '__imul__'


o = MyList()
assert repr(o) == '__repr__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MyList', '__getattribute__')
o[index_value]
assert is_global_value_set('MyList', '__getitem__')
o[index_value] = 43
assert is_global_value_set('MyList', '__setitem__')
del o[index_value]
assert is_global_value_set('MyList', '__delitem__')
iter(o)
assert is_global_value_set('MyList', '__iter__')
len(o)
assert is_global_value_set('MyList', '__len__')
42 in o
assert is_global_value_set('MyList', '__contains__')
o.__reversed__()
assert is_global_value_set('MyList', '__reversed__')
assert o.__add__([]) == '__add__'
assert o + [] == '__add__'
assert o.__mul__([]) == '__mul__'
assert o * [] == '__mul__'
assert o.__rmul__([]) == '__rmul__'
assert [] * o == '__rmul__'
assert o.__iadd__([]) == '__iadd__'
o_copy = o
o_copy += []
assert o_copy == '__iadd__'
assert o.__imul__([]) == '__imul__'
o_copy = o
o_copy *= []
assert o_copy == '__imul__'

# ===========
# === map ===
# ===========

class MyMap(map):

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyMap', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __iter__(self):
        global set_global_value
        set_global_value('MyMap', '__iter__')
        return super().__iter__()

    def __next__(self):
        global set_global_value
        set_global_value('MyMap', '__next__')
        return 'infinite loop'


o = MyMap(lambda: None, [])
getattr(o, attribute_name)
assert is_global_value_set('MyMap', '__getattribute__')
iter(o)
assert is_global_value_set('MyMap', '__iter__')
next(o)
assert is_global_value_set('MyMap', '__next__')

# ==============
# === module ===
# ==============

class MyModule(module):

    def __repr__(self):
        return '__repr__'

    def __dir__(self):
        global dir_value
        return dir_value

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyModule', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __setattr__(self, name, value):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyModule', '__setattr__')
            return None
        return super().__setattr__(name, value)

    def __delattr__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyModule', '__delattr__')
            return None
        return super().__delattr__(name)


o = MyModule('name')
assert repr(o) == '__repr__'
assert dir(o) == dir_value
getattr(o, attribute_name)
assert is_global_value_set('MyModule', '__getattribute__')
setattr(o, attribute_name, 42)
assert is_global_value_set('MyModule', '__setattr__')
delattr(o, attribute_name)
assert is_global_value_set('MyModule', '__delattr__')

# =======================
# === SimpleNamespace ===
# =======================

class MySimpleNamespace(SimpleNamespace):

    def __repr__(self):
        return '__repr__'

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MySimpleNamespace', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __setattr__(self, name, value):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MySimpleNamespace', '__setattr__')
            return None
        return super().__setattr__(name, value)

    def __delattr__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MySimpleNamespace', '__delattr__')
            return None
        return super().__delattr__(name)


o = MySimpleNamespace()
assert repr(o) == '__repr__'
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MySimpleNamespace', '__getattribute__')
setattr(o, attribute_name, 42)
assert is_global_value_set('MySimpleNamespace', '__setattr__')
delattr(o, attribute_name)
assert is_global_value_set('MySimpleNamespace', '__delattr__')

# ==============
# === object ===
# ==============

class MyObject(object):

    def __repr__(self):
        return '__repr__'

    def __str__(self):
        return '__str__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __dir__(self):
        global dir_value
        return dir_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyObject', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __setattr__(self, name, value):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyObject', '__setattr__')
            return None
        return super().__setattr__(name, value)

    def __delattr__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyObject', '__delattr__')
            return None
        return super().__delattr__(name)


o = MyObject()
assert repr(o) == '__repr__'
assert str(o) == '__str__'
assert hash(o) == hash_value
assert dir(o) == dir_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MyObject', '__getattribute__')
setattr(o, attribute_name, 42)
assert is_global_value_set('MyObject', '__setattr__')
delattr(o, attribute_name)
assert is_global_value_set('MyObject', '__delattr__')

# ================
# === property ===
# ================

class MyProperty(property):

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyProperty', '__getattribute__')
            return None
        return super().__getattribute__(name)


o = MyProperty()
getattr(o, attribute_name)
assert is_global_value_set('MyProperty', '__getattribute__')

# ===========
# === set ===
# ===========

class MySet(set):

    def __repr__(self):
        return '__repr__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MySet', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __iter__(self):
        global set_global_value
        set_global_value('MySet', '__iter__')
        return super().__iter__()

    def __len__(self):
        global set_global_value
        set_global_value('MySet', '__len__')
        return 1

    def __contains__(self, element):
        global set_global_value
        set_global_value('MySet', '__contains__')
        return False

    def __and__(self, o):
        return '__and__'

    def __or__(self, o):
        return '__or__'

    def __sub__(self, o):
        return '__sub__'

    def __xor__(self, o):
        return '__xor__'

    def __rand__(self, o):
        return '__rand__'

    def __ror__(self, o):
        return '__ror__'

    def __rsub__(self, o):
        return '__rsub__'

    def __rxor__(self, o):
        return '__rxor__'


o = MySet()
assert repr(o) == '__repr__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MySet', '__getattribute__')
iter(o)
assert is_global_value_set('MySet', '__iter__')
len(o)
assert is_global_value_set('MySet', '__len__')
42 in o
assert is_global_value_set('MySet', '__contains__')
assert o.__and__(set()) == '__and__'
assert o & set() == '__and__'
assert o.__or__(set()) == '__or__'
assert o | set() == '__or__'
assert o.__sub__(set()) == '__sub__'
assert o - set() == '__sub__'
assert o.__xor__(set()) == '__xor__'
assert o ^ set() == '__xor__'
assert o.__rand__(set()) == '__rand__'
assert set() & o == '__rand__'
assert o.__ror__(set()) == '__ror__'
assert set() | o == '__ror__'
assert o.__rsub__(set()) == '__rsub__'
assert set() - o == '__rsub__'
assert o.__rxor__(set()) == '__rxor__'
assert set() ^ o == '__rxor__'

# ====================
# === staticmethod ===
# ====================

class MyStaticmethod(staticmethod):

    def __isabstractmethod__(self):
        global set_global_value
        set_global_value('MyStaticmethod', '__isabstractmethod__')
        return False


o = MyStaticmethod(lambda: None)
o.__isabstractmethod__()
assert is_global_value_set('MyStaticmethod', '__isabstractmethod__')

# ===========
# === str ===
# ===========

class MyStr(str):

    def __repr__(self):
        return '__repr__'

    def __str__(self):
        return '__str__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyStr', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __getitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyStr', '__getitem__')
            return None
        return super().__getitem__(index)

    def __iter__(self):
        global set_global_value
        set_global_value('MyStr', '__iter__')
        return super().__iter__()

    def __len__(self):
        global set_global_value
        set_global_value('MyStr', '__len__')
        return 1

    def __contains__(self, element):
        global set_global_value
        set_global_value('MyStr', '__contains__')
        return False

    def __add__(self, o):
        return '__add__'

    def __mul__(self, o):
        return '__mul__'

    def __rmul__(self, o):
        return '__rmul__'


o = MyStr()
assert repr(o) == '__repr__'
assert str(o) == '__str__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MyStr', '__getattribute__')
o[index_value]
assert is_global_value_set('MyStr', '__getitem__')
iter(o)
assert is_global_value_set('MyStr', '__iter__')
len(o)
assert is_global_value_set('MyStr', '__len__')
42 in o
assert is_global_value_set('MyStr', '__contains__')
assert o.__add__('') == '__add__'
assert o + '' == '__add__'
assert o.__mul__('') == '__mul__'
assert o * '' == '__mul__'
assert o.__rmul__('') == '__rmul__'
assert '' * o == '__rmul__'

# =============
# === tuple ===
# =============

class MyTuple(tuple):

    def __repr__(self):
        return '__repr__'

    def __hash__(self):
        global hash_value
        return hash_value

    def __eq__(self, o):
        return o == '__eq__'

    def __ne__(self, o):
        return o == '__ne__'

    def __lt__(self, o):
        return o == '__lt__'

    def __le__(self, o):
        return o == '__le__'

    def __gt__(self, o):
        return o == '__gt__'

    def __ge__(self, o):
        return o == '__ge__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyTuple', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __getitem__(self, index):
        global index_value
        if index == index_value:
            global set_global_value
            set_global_value('MyTuple', '__getitem__')
            return None
        return super().__getitem__(index)

    def __iter__(self):
        global set_global_value
        set_global_value('MyTuple', '__iter__')
        return super().__iter__()

    def __len__(self):
        global set_global_value
        set_global_value('MyTuple', '__len__')
        return 1

    def __contains__(self, element):
        global set_global_value
        set_global_value('MyTuple', '__contains__')
        return False

    def __add__(self, o):
        return '__add__'

    def __mul__(self, o):
        return '__mul__'

    def __rmul__(self, o):
        return '__rmul__'


o = MyTuple()
assert repr(o) == '__repr__'
assert hash(o) == hash_value
assert o == '__eq__'
assert o != '__ne__'
assert o < '__lt__'
assert o <= '__le__'
assert o > '__gt__'
assert o >= '__ge__'
getattr(o, attribute_name)
assert is_global_value_set('MyTuple', '__getattribute__')
o[index_value]
assert is_global_value_set('MyTuple', '__getitem__')
iter(o)
assert is_global_value_set('MyTuple', '__iter__')
len(o)
assert is_global_value_set('MyTuple', '__len__')
42 in o
assert is_global_value_set('MyTuple', '__contains__')
assert o.__add__(()) == '__add__'
assert o + () == '__add__'
assert o.__mul__(()) == '__mul__'
assert o * () == '__mul__'
assert o.__rmul__(()) == '__rmul__'
assert () * o == '__rmul__'

# ============
# === type ===
# ============

class MyType(type):

    def __repr__(self):
        return '__repr__'

    def __dir__(self):
        global dir_value
        return dir_value

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyType', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __setattr__(self, name, value):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyType', '__setattr__')
            return None
        return super().__setattr__(name, value)

    def __delattr__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyType', '__delattr__')
            return None
        return super().__delattr__(name)

    def __call__(self, args=None, kwargs=None):
        return '__call__'

    def __instancecheck__(self, object):
        global set_global_value
        set_global_value('MyType', '__instancecheck__')
        return False

    def __subclasscheck__(self, subclass):
        global set_global_value
        set_global_value('MyType', '__subclasscheck__')
        return False


o = MyType('Name', (), {})
assert repr(o) == '__repr__'
assert dir(o) == dir_value
getattr(o, attribute_name)
assert is_global_value_set('MyType', '__getattribute__')
setattr(o, attribute_name, 42)
assert is_global_value_set('MyType', '__setattr__')
delattr(o, attribute_name)
assert is_global_value_set('MyType', '__delattr__')
assert o() == '__call__'
isinstance(42, o)
assert is_global_value_set('MyType', '__instancecheck__')
issubclass(int, o)
assert is_global_value_set('MyType', '__subclasscheck__')

# ===========
# === zip ===
# ===========

class MyZip(zip):

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyZip', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __iter__(self):
        global set_global_value
        set_global_value('MyZip', '__iter__')
        return super().__iter__()

    def __next__(self):
        global set_global_value
        set_global_value('MyZip', '__next__')
        return 'infinite loop'


o = MyZip()
getattr(o, attribute_name)
assert is_global_value_set('MyZip', '__getattribute__')
iter(o)
assert is_global_value_set('MyZip', '__iter__')
next(o)
assert is_global_value_set('MyZip', '__next__')

# =====================
# === BaseException ===
# =====================

class MyBaseException(BaseException):

    def __repr__(self):
        return '__repr__'

    def __str__(self):
        return '__str__'

    def __getattribute__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyBaseException', '__getattribute__')
            return None
        return super().__getattribute__(name)

    def __setattr__(self, name, value):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyBaseException', '__setattr__')
            return None
        return super().__setattr__(name, value)

    def __delattr__(self, name):
        global attribute_name
        if name == attribute_name:
            global set_global_value
            set_global_value('MyBaseException', '__delattr__')
            return None
        return super().__delattr__(name)


o = MyBaseException()
assert repr(o) == '__repr__'
assert str(o) == '__str__'
getattr(o, attribute_name)
assert is_global_value_set('MyBaseException', '__getattribute__')
setattr(o, attribute_name, 42)
assert is_global_value_set('MyBaseException', '__setattr__')
delattr(o, attribute_name)
assert is_global_value_set('MyBaseException', '__delattr__')

# ===================
# === ImportError ===
# ===================

class MyImportError(ImportError):

    def __str__(self):
        return '__str__'


o = MyImportError()
assert str(o) == '__str__'

# ================
# === KeyError ===
# ================

class MyKeyError(KeyError):

    def __str__(self):
        return '__str__'


o = MyKeyError()
assert str(o) == '__str__'

# ===================
# === SyntaxError ===
# ===================

class MySyntaxError(SyntaxError):

    def __str__(self):
        return '__str__'


o = MySyntaxError()
assert str(o) == '__str__'

