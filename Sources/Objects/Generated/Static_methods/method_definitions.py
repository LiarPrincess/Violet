from typing import NamedTuple


class StaticMethodKind(NamedTuple):
    name: str
    example: str


_hash = StaticMethodKind('Hash', 'func hash() -> HashResult')
_stringConversion = StaticMethodKind('StringConversion', 'func repr() -> PyResult<String>')
_comparison = StaticMethodKind('Comparison', 'func isEqual(_ other: PyObject) -> CompareResult')
_asBool = StaticMethodKind('AsBool', 'func asBool() -> PyBool')
_asFloat = StaticMethodKind('AsFloat', 'func asFloat() -> PyResult<PyFloat>')
_asInt = StaticMethodKind('AsInt', 'func asInt() -> PyResult<PyInt>')
_asComplex = StaticMethodKind('AsComplex', 'func asComplex() -> PyObject')
_asIndex = StaticMethodKind('AsIndex', 'func asIndex() -> BigInt')
_getAttribute = StaticMethodKind('GetAttribute', 'func getAttribute(name: PyObject) -> PyResult<PyObject>')
_setAttribute = StaticMethodKind('SetAttribute', 'func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone>')
_delAttribute = StaticMethodKind('DelAttribute', 'func delAttribute(name: PyObject) -> PyResult<PyNone>')
_getItem = StaticMethodKind('GetItem', 'func getItem(index: PyObject) -> PyResult<PyObject>')
_setItem = StaticMethodKind('SetItem', 'func setItem(index: PyObject, value: PyObject) -> PyResult<PyNone>')
_delItem = StaticMethodKind('DelItem', 'func delItem(index: PyObject) -> PyResult<PyNone>')
_iter = StaticMethodKind('Iter', 'func iter() -> PyObject')
_next = StaticMethodKind('Next', 'func next() -> PyResult<PyObject>')
_getLength = StaticMethodKind('GetLength', 'func getLength() -> BigInt')
_contains = StaticMethodKind('Contains', 'func contains(element: PyObject) -> PyResult<PyBool>')
_reversed = StaticMethodKind('Reversed', 'func reversed() -> PyObject')
_keys = StaticMethodKind('Keys', 'func keys() -> PyObject')
_del = StaticMethodKind('Del', 'func del() -> PyResult<PyNone>')
_dir = StaticMethodKind('Dir', 'func dir() -> PyResult<DirResult>')
_call = StaticMethodKind('Call', 'func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>')
_isType = StaticMethodKind('IsType', 'func isType(of object: PyObject) -> Bool')
_isSubtype = StaticMethodKind('IsSubtype', 'func isSubtype(of object: PyObject) -> PyResult<Bool>')
_isAbstractMethod = StaticMethodKind('IsAbstractMethod', 'func isAbstractMethod() -> PyResult<Bool>')
_numericUnary = StaticMethodKind('NumericUnary', 'func positive() -> PyObject')
_numericTrunc = StaticMethodKind('NumericTrunc', 'func trunc() -> PyResult<PyInt>')
_numericRound = StaticMethodKind('NumericRound', 'func round(nDigits: PyObject?) -> PyResult<PyObject>')
_numericBinary = StaticMethodKind('NumericBinary', 'func add(_ other: PyObject) -> PyResult<PyObject>')
_numericTernary = StaticMethodKind('NumericTernary', 'func pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject>')


class StaticMethod(NamedTuple):
    name: str
    kind: StaticMethodKind


STATIC_METHODS = [

    StaticMethod('__repr__', _stringConversion),
    StaticMethod('__str__', _stringConversion),

    StaticMethod('__hash__', _hash),

    StaticMethod('__eq__', _comparison),
    StaticMethod('__ne__', _comparison),
    StaticMethod('__lt__', _comparison),
    StaticMethod('__le__', _comparison),
    StaticMethod('__gt__', _comparison),
    StaticMethod('__ge__', _comparison),

    StaticMethod('__bool__', _asBool),
    StaticMethod('__int__', _asInt),
    StaticMethod('__float__', _asFloat),
    StaticMethod('__complex__', _asComplex),
    StaticMethod('__index__', _asIndex),

    StaticMethod('__getattr__', _getAttribute),
    StaticMethod('__getattribute__', _getAttribute),
    StaticMethod('__setattr__', _setAttribute),
    StaticMethod('__delattr__', _delAttribute),

    StaticMethod('__getitem__', _getItem),
    StaticMethod('__setitem__', _setItem),
    StaticMethod('__delitem__', _delItem),

    StaticMethod('__iter__', _iter),
    StaticMethod('__next__', _next),
    StaticMethod('__len__', _getLength),
    StaticMethod('__contains__', _contains),
    StaticMethod('__reversed__', _reversed),
    StaticMethod('keys', _keys),

    StaticMethod('__del__', _del),
    StaticMethod('__dir__', _dir),

    StaticMethod('__call__', _call),

    StaticMethod('__instancecheck__', _isType),
    StaticMethod('__subclasscheck__', _isSubtype),
    StaticMethod('__isabstractmethod__', _isAbstractMethod),

    StaticMethod('__pos__', _numericUnary),
    StaticMethod('__neg__', _numericUnary),
    StaticMethod('__abs__', _numericUnary),
    StaticMethod('__invert__', _numericUnary),

    StaticMethod('__trunc__', _numericTrunc),
    StaticMethod('__round__', _numericRound),

    StaticMethod('__add__', _numericBinary),
    StaticMethod('__and__', _numericBinary),
    StaticMethod('__divmod__', _numericBinary),
    StaticMethod('__floordiv__', _numericBinary),
    StaticMethod('__lshift__', _numericBinary),
    StaticMethod('__matmul__', _numericBinary),
    StaticMethod('__mod__', _numericBinary),
    StaticMethod('__mul__', _numericBinary),
    StaticMethod('__or__', _numericBinary),
    StaticMethod('__rshift__', _numericBinary),
    StaticMethod('__sub__', _numericBinary),
    StaticMethod('__truediv__', _numericBinary),
    StaticMethod('__xor__', _numericBinary),

    StaticMethod('__radd__', _numericBinary),
    StaticMethod('__rand__', _numericBinary),
    StaticMethod('__rdivmod__', _numericBinary),
    StaticMethod('__rfloordiv__', _numericBinary),
    StaticMethod('__rlshift__', _numericBinary),
    StaticMethod('__rmatmul__', _numericBinary),
    StaticMethod('__rmod__', _numericBinary),
    StaticMethod('__rmul__', _numericBinary),
    StaticMethod('__ror__', _numericBinary),
    StaticMethod('__rrshift__', _numericBinary),
    StaticMethod('__rsub__', _numericBinary),
    StaticMethod('__rtruediv__', _numericBinary),
    StaticMethod('__rxor__', _numericBinary),

    StaticMethod('__iadd__', _numericBinary),
    StaticMethod('__iand__', _numericBinary),
    StaticMethod('__idivmod__', _numericBinary),
    StaticMethod('__ifloordiv__', _numericBinary),
    StaticMethod('__ilshift__', _numericBinary),
    StaticMethod('__imatmul__', _numericBinary),
    StaticMethod('__imod__', _numericBinary),
    StaticMethod('__imul__', _numericBinary),
    StaticMethod('__ior__', _numericBinary),
    StaticMethod('__irshift__', _numericBinary),
    StaticMethod('__isub__', _numericBinary),
    StaticMethod('__itruediv__', _numericBinary),
    StaticMethod('__ixor__', _numericBinary),

    StaticMethod('__pow__', _numericTernary),
    StaticMethod('__rpow__', _numericTernary),
    StaticMethod('__ipow__', _numericTernary),
]
