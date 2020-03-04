import Core

// Sometimes instead of doing slow Python dispatch we will use Swift protocols.
// Feel free to add new protocols if you need them (just modify the script
// responsible for generating the code).

// swiftlint:disable line_length

protocol __new__Owner {
  static func pyNew(type: PyType, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>
}

protocol __init__Owner {
  associatedtype Zelf: PyObject
  static func pyInit(zelf: Zelf, args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone>
}

protocol __abs__Owner { func abs() -> PyObject }
protocol __add__Owner { func add(_ other: PyObject) -> PyResult<PyObject> }
protocol __and__Owner { func and(_ other: PyObject) -> PyResult<PyObject> }
protocol __bool__Owner { func asBool() -> Bool }
protocol __call__Owner { func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> }
protocol __complex__Owner { func asComplex() -> PyObject }
protocol __contains__Owner { func contains(_ element: PyObject) -> PyResult<Bool> }
protocol __del__Owner { func del() -> PyResult<PyNone> }
protocol __delitem__Owner { func delItem(at index: PyObject) -> PyResult<PyNone> }
protocol __dict__GetterOwner { func getDict() -> PyDict }
protocol __dir__Owner { func dir() -> DirResult }
protocol __divmod__Owner { func divmod(_ other: PyObject) -> PyResult<PyObject> }
protocol __eq__Owner { func isEqual(_ other: PyObject) -> CompareResult }
protocol __float__Owner { func asFloat() -> PyResult<PyFloat> }
protocol __floordiv__Owner { func floordiv(_ other: PyObject) -> PyResult<PyObject> }
protocol __ge__Owner { func isGreaterEqual(_ other: PyObject) -> CompareResult }
protocol __getattribute__Owner { func getAttribute(name: PyObject) -> PyResult<PyObject> }
protocol __getitem__Owner { func getItem(at index: PyObject) -> PyResult<PyObject> }
protocol __gt__Owner { func isGreater(_ other: PyObject) -> CompareResult }
protocol __hash__Owner { func hash() -> HashResult }
protocol __iadd__Owner { func iadd(_ other: PyObject) -> PyResult<PyObject> }
protocol __iand__Owner { func iand(_ other: PyObject) -> PyResult<PyObject> }
protocol __ifloordiv__Owner { func ifloordiv(_ other: PyObject) -> PyResult<PyObject> }
protocol __ilshift__Owner { func ilshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __imatmul__Owner { func imatmul(_ other: PyObject) -> PyResult<PyObject> }
protocol __imod__Owner { func imod(_ other: PyObject) -> PyResult<PyObject> }
protocol __imul__Owner { func imul(_ other: PyObject) -> PyResult<PyObject> }
protocol __index__Owner { func asIndex() -> BigInt }
protocol __instancecheck__Owner { func isType(of object: PyObject) -> Bool }
protocol __invert__Owner { func invert() -> PyObject }
protocol __ior__Owner { func ior(_ other: PyObject) -> PyResult<PyObject> }
protocol __ipow__Owner { func ipow(_ other: PyObject) -> PyResult<PyObject> }
protocol __irshift__Owner { func irshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __isabstractmethod__Owner { func isAbstractMethod() -> PyResult<Bool> }
protocol __isub__Owner { func isub(_ other: PyObject) -> PyResult<PyObject> }
protocol __iter__Owner { func iter() -> PyObject }
protocol __itruediv__Owner { func itruediv(_ other: PyObject) -> PyResult<PyObject> }
protocol __ixor__Owner { func ixor(_ other: PyObject) -> PyResult<PyObject> }
protocol __le__Owner { func isLessEqual(_ other: PyObject) -> CompareResult }
protocol __len__Owner { func getLength() -> BigInt }
protocol __lshift__Owner { func lshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __lt__Owner { func isLess(_ other: PyObject) -> CompareResult }
protocol __matmul__Owner { func matmul(_ other: PyObject) -> PyResult<PyObject> }
protocol __mod__Owner { func mod(_ other: PyObject) -> PyResult<PyObject> }
protocol __mul__Owner { func mul(_ other: PyObject) -> PyResult<PyObject> }
protocol __ne__Owner { func isNotEqual(_ other: PyObject) -> CompareResult }
protocol __neg__Owner { func negative() -> PyObject }
protocol __next__Owner { func next() -> PyResult<PyObject> }
protocol __or__Owner { func or(_ other: PyObject) -> PyResult<PyObject> }
protocol __pos__Owner { func positive() -> PyObject }
protocol __pow__Owner { func pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject> }
protocol __radd__Owner { func radd(_ other: PyObject) -> PyResult<PyObject> }
protocol __rand__Owner { func rand(_ other: PyObject) -> PyResult<PyObject> }
protocol __rdivmod__Owner { func rdivmod(_ other: PyObject) -> PyResult<PyObject> }
protocol __repr__Owner { func repr() -> PyResult<String> }
protocol __reversed__Owner { func reversed() -> PyObject }
protocol __rfloordiv__Owner { func rfloordiv(_ other: PyObject) -> PyResult<PyObject> }
protocol __rlshift__Owner { func rlshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __rmatmul__Owner { func rmatmul(_ other: PyObject) -> PyResult<PyObject> }
protocol __rmod__Owner { func rmod(_ other: PyObject) -> PyResult<PyObject> }
protocol __rmul__Owner { func rmul(_ other: PyObject) -> PyResult<PyObject> }
protocol __ror__Owner { func ror(_ other: PyObject) -> PyResult<PyObject> }
protocol __round__Owner { func round(nDigits: PyObject?) -> PyResult<PyObject> }
protocol __rpow__Owner { func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> }
protocol __rrshift__Owner { func rrshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __rshift__Owner { func rshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __rsub__Owner { func rsub(_ other: PyObject) -> PyResult<PyObject> }
protocol __rtruediv__Owner { func rtruediv(_ other: PyObject) -> PyResult<PyObject> }
protocol __rxor__Owner { func rxor(_ other: PyObject) -> PyResult<PyObject> }
protocol __setattr__Owner { func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> }
protocol __setitem__Owner { func setItem(at index: PyObject, to value: PyObject) -> PyResult<PyNone> }
protocol __str__Owner { func str() -> PyResult<String> }
protocol __sub__Owner { func sub(_ other: PyObject) -> PyResult<PyObject> }
protocol __subclasscheck__Owner { func isSubtype(of object: PyObject) -> PyResult<Bool> }
protocol __truediv__Owner { func truediv(_ other: PyObject) -> PyResult<PyObject> }
protocol __trunc__Owner { func trunc() -> PyObject }
protocol __xor__Owner { func xor(_ other: PyObject) -> PyResult<PyObject> }
protocol keysOwner { func keys() -> PyObject }
