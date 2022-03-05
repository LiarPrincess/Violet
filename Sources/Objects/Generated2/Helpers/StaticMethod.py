from typing import List, NamedTuple


class Argument(NamedTuple):
    name: str
    typ: str
    has_underscore_label: bool


class StaticMethodKind:

    def __init__(self, name: str, signature: str):
        self.name = name
        self.signature = signature

        split = signature.split('->')
        assert len(split) == 2
        self.return_type = split[1].strip()

        arguments = split[0].strip()

        # Remove '(' and ')'
        assert arguments.startswith('(')
        assert arguments.endswith(')')
        arguments = arguments[1:-1].strip()

        self.arguments: List[Argument] = []
        argument_split = arguments.split(', ')
        for arg in argument_split:
            # On 'func' arguments: '_ object: PyObject' vs 'object: PyObject'
            has_underscore_label = arg.startswith('_')
            if has_underscore_label:
                arg = arg[1:]

            arg_split = arg.split(': ')
            assert len(arg_split) == 2

            arg_name = arg_split[0].strip()
            arg_typ = arg_split[1].strip()
            self.arguments.append(Argument(arg_name, arg_typ, has_underscore_label))


_stringConversion = StaticMethodKind('StringConversion', '(_ py: Py, object: PyObject) -> PyResult<PyObject>')
_hash = StaticMethodKind('Hash', '(_ py: Py, object: PyObject) -> HashResult')
_dir = StaticMethodKind('Dir', '(_ py: Py, object: PyObject) -> PyResult<DirResult>')
_comparison = StaticMethodKind('Comparison', '(_ py: Py, left: PyObject, right: PyObject) -> CompareResult')
_asBool = StaticMethodKind('AsBool', '(_ py: Py, object: PyObject) -> PyBool')
_asInt = StaticMethodKind('AsInt', '(_ py: Py, object: PyObject) -> PyResult<PyInt>')
_asFloat = StaticMethodKind('AsFloat', '(_ py: Py, object: PyObject) -> PyResult<PyFloat>')
_asComplex = StaticMethodKind('AsComplex', '(_ py: Py, object: PyObject) -> PyObject')
_asIndex = StaticMethodKind('AsIndex', '(_ py: Py, object: PyObject) -> PyInt')
_getAttribute = StaticMethodKind('GetAttribute', '(_ py: Py, object: PyObject, name: PyObject) -> PyResult<PyObject>')
_setAttribute = StaticMethodKind('SetAttribute', '(_ py: Py, object: PyObject, name: PyObject, value: PyObject?) -> PyResult<PyObject>')
_delAttribute = StaticMethodKind('DelAttribute', '(_ py: Py, object: PyObject, name: PyObject) -> PyResult<PyObject>')
_getItem = StaticMethodKind('GetItem', '(_ py: Py, object: PyObject, index: PyObject) -> PyResult<PyObject>')
_setItem = StaticMethodKind('SetItem', '(_ py: Py, object: PyObject, index: PyObject, value: PyObject) -> PyResult<PyObject>')
_delItem = StaticMethodKind('DelItem', '(_ py: Py, object: PyObject, index: PyObject) -> PyResult<PyObject>')
_iter = StaticMethodKind('Iter', '(_ py: Py, object: PyObject) -> PyObject')
_next = StaticMethodKind('Next', '(_ py: Py, object: PyObject) -> PyResult<PyObject>')
_getLength = StaticMethodKind('GetLength', '(_ py: Py, object: PyObject) -> PyInt')
_contains = StaticMethodKind('Contains', '(_ py: Py, object: PyObject, element: PyObject) -> PyResult<PyBool>')
_reversed = StaticMethodKind('Reversed', '(_ py: Py, object: PyObject) -> PyObject')
_keys = StaticMethodKind('Keys', '(_ py: Py, object: PyObject) -> PyObject')
_del = StaticMethodKind('Del', '(_ py: Py, object: PyObject) -> PyResult<PyObject>')
_call = StaticMethodKind('Call', '(_ py: Py, object: PyObject, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>')
_instanceCheck = StaticMethodKind('InstanceCheck', '(_ py: Py, type: PyObject, object: PyObject) -> PyBool')
_subclassCheck = StaticMethodKind('SubclassCheck', '(_ py: Py, type: PyObject, base: PyObject) -> PyResult<PyBool>')
_isAbstractMethod = StaticMethodKind('IsAbstractMethod', '(_ py: Py, object: PyObject) -> PyResult<PyBool>')
_numericUnary = StaticMethodKind('NumericUnary', '(_ py: Py, object: PyObject) -> PyObject')
_numericTrunc = StaticMethodKind('NumericTrunc', '(_ py: Py, object: PyObject) -> PyResult<PyInt>')
_numericRound = StaticMethodKind('NumericRound', '(_ py: Py, object: PyObject, nDigits: PyObject?) -> PyResult<PyObject>')
_numericBinary = StaticMethodKind('NumericBinary', '(_ py: Py, left: PyObject, right: PyObject) -> PyResult<PyObject>')
_numericPow = StaticMethodKind('NumericPow', '(_ py: Py, base: PyObject, exp: PyObject, mod: PyObject) -> PyResult<PyObject>')


class StaticMethod(NamedTuple):
    name: str
    kind: StaticMethodKind


ALL_STATIC_METHODS = [

    StaticMethod('__repr__', _stringConversion),
    StaticMethod('__str__', _stringConversion),

    StaticMethod('__hash__', _hash),
    StaticMethod('__dir__', _dir),

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
    StaticMethod('__call__', _call),

    StaticMethod('__instancecheck__', _instanceCheck),
    StaticMethod('__subclasscheck__', _subclassCheck),
    StaticMethod('__isabstractmethod__', _isAbstractMethod),

    StaticMethod('__pos__', _numericUnary),
    StaticMethod('__neg__', _numericUnary),
    StaticMethod('__invert__', _numericUnary),
    StaticMethod('__abs__', _numericUnary),

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

    StaticMethod('__pow__', _numericPow),
    StaticMethod('__rpow__', _numericPow),
    StaticMethod('__ipow__', _numericPow),
]
