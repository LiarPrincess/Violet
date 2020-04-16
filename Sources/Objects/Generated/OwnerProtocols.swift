// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable discouraged_optional_boolean

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

import Core

// Sometimes instead of doing slow Python dispatch we will use Swift protocols.
// Feel free to add new protocols if you need them (just modify the script
// responsible for generating the code).

// This protocol is here only to check if we have consistent '__new__' signatures.
// It will not be used in 'Fast' dispatch.
protocol __new__Owner {
  static func pyNew(type: PyType, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>
}

// This protocol is here only to check if we have consistent '__init__' signatures.
// It will not be used in 'Fast' dispatch.
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
protocol __dir__Owner { func dir() -> PyResult<DirResult> }
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

internal enum Fast {

  internal static func __abs__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __abs__Owner, !zelf.hasOverriden(selector: "__abs__") {
      return owner.abs()
    }

    return nil
  }

  internal static func __add__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __add__Owner, !zelf.hasOverriden(selector: "__add__") {
      return owner.add(other)
    }

    return nil
  }

  internal static func __and__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __and__Owner, !zelf.hasOverriden(selector: "__and__") {
      return owner.and(other)
    }

    return nil
  }

  internal static func __bool__(_ zelf: PyObject) -> Bool? {
    if let owner = zelf as? __bool__Owner, !zelf.hasOverriden(selector: "__bool__") {
      return owner.asBool()
    }

    return nil
  }

  internal static func __call__(_ zelf: PyObject, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>? {
    if let owner = zelf as? __call__Owner, !zelf.hasOverriden(selector: "__call__") {
      return owner.call(args: args, kwargs: kwargs)
    }

    return nil
  }

  internal static func __complex__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __complex__Owner, !zelf.hasOverriden(selector: "__complex__") {
      return owner.asComplex()
    }

    return nil
  }

  internal static func __contains__(_ zelf: PyObject, _ element: PyObject) -> PyResult<Bool>? {
    if let owner = zelf as? __contains__Owner, !zelf.hasOverriden(selector: "__contains__") {
      return owner.contains(element)
    }

    return nil
  }

  internal static func __del__(_ zelf: PyObject) -> PyResult<PyNone>? {
    if let owner = zelf as? __del__Owner, !zelf.hasOverriden(selector: "__del__") {
      return owner.del()
    }

    return nil
  }

  internal static func __delitem__(_ zelf: PyObject, at index: PyObject) -> PyResult<PyNone>? {
    if let owner = zelf as? __delitem__Owner, !zelf.hasOverriden(selector: "__delitem__") {
      return owner.delItem(at: index)
    }

    return nil
  }

  internal static func __dict__(_ zelf: PyObject) -> PyDict? {
    if let owner = zelf as? __dict__GetterOwner, !zelf.hasOverriden(selector: "__dict__") {
      return owner.getDict()
    }

    return nil
  }

  internal static func __dir__(_ zelf: PyObject) -> PyResult<DirResult>? {
    if let owner = zelf as? __dir__Owner, !zelf.hasOverriden(selector: "__dir__") {
      return owner.dir()
    }

    return nil
  }

  internal static func __divmod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __divmod__Owner, !zelf.hasOverriden(selector: "__divmod__") {
      return owner.divmod(other)
    }

    return nil
  }

  internal static func __eq__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __eq__Owner, !zelf.hasOverriden(selector: "__eq__") {
      return owner.isEqual(other)
    }

    return nil
  }

  internal static func __float__(_ zelf: PyObject) -> PyResult<PyFloat>? {
    if let owner = zelf as? __float__Owner, !zelf.hasOverriden(selector: "__float__") {
      return owner.asFloat()
    }

    return nil
  }

  internal static func __floordiv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __floordiv__Owner, !zelf.hasOverriden(selector: "__floordiv__") {
      return owner.floordiv(other)
    }

    return nil
  }

  internal static func __ge__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __ge__Owner, !zelf.hasOverriden(selector: "__ge__") {
      return owner.isGreaterEqual(other)
    }

    return nil
  }

  internal static func __getattribute__(_ zelf: PyObject, name: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __getattribute__Owner, !zelf.hasOverriden(selector: "__getattribute__") {
      return owner.getAttribute(name: name)
    }

    return nil
  }

  internal static func __getitem__(_ zelf: PyObject, at index: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __getitem__Owner, !zelf.hasOverriden(selector: "__getitem__") {
      return owner.getItem(at: index)
    }

    return nil
  }

  internal static func __gt__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __gt__Owner, !zelf.hasOverriden(selector: "__gt__") {
      return owner.isGreater(other)
    }

    return nil
  }

  internal static func __hash__(_ zelf: PyObject) -> HashResult? {
    if let owner = zelf as? __hash__Owner, !zelf.hasOverriden(selector: "__hash__") {
      return owner.hash()
    }

    return nil
  }

  internal static func __iadd__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __iadd__Owner, !zelf.hasOverriden(selector: "__iadd__") {
      return owner.iadd(other)
    }

    return nil
  }

  internal static func __iand__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __iand__Owner, !zelf.hasOverriden(selector: "__iand__") {
      return owner.iand(other)
    }

    return nil
  }

  internal static func __ifloordiv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ifloordiv__Owner, !zelf.hasOverriden(selector: "__ifloordiv__") {
      return owner.ifloordiv(other)
    }

    return nil
  }

  internal static func __ilshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ilshift__Owner, !zelf.hasOverriden(selector: "__ilshift__") {
      return owner.ilshift(other)
    }

    return nil
  }

  internal static func __imatmul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __imatmul__Owner, !zelf.hasOverriden(selector: "__imatmul__") {
      return owner.imatmul(other)
    }

    return nil
  }

  internal static func __imod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __imod__Owner, !zelf.hasOverriden(selector: "__imod__") {
      return owner.imod(other)
    }

    return nil
  }

  internal static func __imul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __imul__Owner, !zelf.hasOverriden(selector: "__imul__") {
      return owner.imul(other)
    }

    return nil
  }

  internal static func __index__(_ zelf: PyObject) -> BigInt? {
    if let owner = zelf as? __index__Owner, !zelf.hasOverriden(selector: "__index__") {
      return owner.asIndex()
    }

    return nil
  }

  internal static func __instancecheck__(_ zelf: PyObject, of object: PyObject) -> Bool? {
    if let owner = zelf as? __instancecheck__Owner, !zelf.hasOverriden(selector: "__instancecheck__") {
      return owner.isType(of: object)
    }

    return nil
  }

  internal static func __invert__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __invert__Owner, !zelf.hasOverriden(selector: "__invert__") {
      return owner.invert()
    }

    return nil
  }

  internal static func __ior__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ior__Owner, !zelf.hasOverriden(selector: "__ior__") {
      return owner.ior(other)
    }

    return nil
  }

  internal static func __ipow__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ipow__Owner, !zelf.hasOverriden(selector: "__ipow__") {
      return owner.ipow(other)
    }

    return nil
  }

  internal static func __irshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __irshift__Owner, !zelf.hasOverriden(selector: "__irshift__") {
      return owner.irshift(other)
    }

    return nil
  }

  internal static func __isabstractmethod__(_ zelf: PyObject) -> PyResult<Bool>? {
    if let owner = zelf as? __isabstractmethod__Owner, !zelf.hasOverriden(selector: "__isabstractmethod__") {
      return owner.isAbstractMethod()
    }

    return nil
  }

  internal static func __isub__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __isub__Owner, !zelf.hasOverriden(selector: "__isub__") {
      return owner.isub(other)
    }

    return nil
  }

  internal static func __iter__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __iter__Owner, !zelf.hasOverriden(selector: "__iter__") {
      return owner.iter()
    }

    return nil
  }

  internal static func __itruediv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __itruediv__Owner, !zelf.hasOverriden(selector: "__itruediv__") {
      return owner.itruediv(other)
    }

    return nil
  }

  internal static func __ixor__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ixor__Owner, !zelf.hasOverriden(selector: "__ixor__") {
      return owner.ixor(other)
    }

    return nil
  }

  internal static func __le__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __le__Owner, !zelf.hasOverriden(selector: "__le__") {
      return owner.isLessEqual(other)
    }

    return nil
  }

  internal static func __len__(_ zelf: PyObject) -> BigInt? {
    if let owner = zelf as? __len__Owner, !zelf.hasOverriden(selector: "__len__") {
      return owner.getLength()
    }

    return nil
  }

  internal static func __lshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __lshift__Owner, !zelf.hasOverriden(selector: "__lshift__") {
      return owner.lshift(other)
    }

    return nil
  }

  internal static func __lt__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __lt__Owner, !zelf.hasOverriden(selector: "__lt__") {
      return owner.isLess(other)
    }

    return nil
  }

  internal static func __matmul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __matmul__Owner, !zelf.hasOverriden(selector: "__matmul__") {
      return owner.matmul(other)
    }

    return nil
  }

  internal static func __mod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __mod__Owner, !zelf.hasOverriden(selector: "__mod__") {
      return owner.mod(other)
    }

    return nil
  }

  internal static func __mul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __mul__Owner, !zelf.hasOverriden(selector: "__mul__") {
      return owner.mul(other)
    }

    return nil
  }

  internal static func __ne__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __ne__Owner, !zelf.hasOverriden(selector: "__ne__") {
      return owner.isNotEqual(other)
    }

    return nil
  }

  internal static func __neg__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __neg__Owner, !zelf.hasOverriden(selector: "__neg__") {
      return owner.negative()
    }

    return nil
  }

  internal static func __next__(_ zelf: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __next__Owner, !zelf.hasOverriden(selector: "__next__") {
      return owner.next()
    }

    return nil
  }

  internal static func __or__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __or__Owner, !zelf.hasOverriden(selector: "__or__") {
      return owner.or(other)
    }

    return nil
  }

  internal static func __pos__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __pos__Owner, !zelf.hasOverriden(selector: "__pos__") {
      return owner.positive()
    }

    return nil
  }

  internal static func __pow__(_ zelf: PyObject, exp: PyObject, mod: PyObject?) -> PyResult<PyObject>? {
    if let owner = zelf as? __pow__Owner, !zelf.hasOverriden(selector: "__pow__") {
      return owner.pow(exp: exp, mod: mod)
    }

    return nil
  }

  internal static func __radd__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __radd__Owner, !zelf.hasOverriden(selector: "__radd__") {
      return owner.radd(other)
    }

    return nil
  }

  internal static func __rand__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rand__Owner, !zelf.hasOverriden(selector: "__rand__") {
      return owner.rand(other)
    }

    return nil
  }

  internal static func __rdivmod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rdivmod__Owner, !zelf.hasOverriden(selector: "__rdivmod__") {
      return owner.rdivmod(other)
    }

    return nil
  }

  internal static func __repr__(_ zelf: PyObject) -> PyResult<String>? {
    if let owner = zelf as? __repr__Owner, !zelf.hasOverriden(selector: "__repr__") {
      return owner.repr()
    }

    return nil
  }

  internal static func __reversed__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __reversed__Owner, !zelf.hasOverriden(selector: "__reversed__") {
      return owner.reversed()
    }

    return nil
  }

  internal static func __rfloordiv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rfloordiv__Owner, !zelf.hasOverriden(selector: "__rfloordiv__") {
      return owner.rfloordiv(other)
    }

    return nil
  }

  internal static func __rlshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rlshift__Owner, !zelf.hasOverriden(selector: "__rlshift__") {
      return owner.rlshift(other)
    }

    return nil
  }

  internal static func __rmatmul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rmatmul__Owner, !zelf.hasOverriden(selector: "__rmatmul__") {
      return owner.rmatmul(other)
    }

    return nil
  }

  internal static func __rmod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rmod__Owner, !zelf.hasOverriden(selector: "__rmod__") {
      return owner.rmod(other)
    }

    return nil
  }

  internal static func __rmul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rmul__Owner, !zelf.hasOverriden(selector: "__rmul__") {
      return owner.rmul(other)
    }

    return nil
  }

  internal static func __ror__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ror__Owner, !zelf.hasOverriden(selector: "__ror__") {
      return owner.ror(other)
    }

    return nil
  }

  internal static func __round__(_ zelf: PyObject, nDigits: PyObject?) -> PyResult<PyObject>? {
    if let owner = zelf as? __round__Owner, !zelf.hasOverriden(selector: "__round__") {
      return owner.round(nDigits: nDigits)
    }

    return nil
  }

  internal static func __rpow__(_ zelf: PyObject, base: PyObject, mod: PyObject?) -> PyResult<PyObject>? {
    if let owner = zelf as? __rpow__Owner, !zelf.hasOverriden(selector: "__rpow__") {
      return owner.rpow(base: base, mod: mod)
    }

    return nil
  }

  internal static func __rrshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rrshift__Owner, !zelf.hasOverriden(selector: "__rrshift__") {
      return owner.rrshift(other)
    }

    return nil
  }

  internal static func __rshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rshift__Owner, !zelf.hasOverriden(selector: "__rshift__") {
      return owner.rshift(other)
    }

    return nil
  }

  internal static func __rsub__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rsub__Owner, !zelf.hasOverriden(selector: "__rsub__") {
      return owner.rsub(other)
    }

    return nil
  }

  internal static func __rtruediv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rtruediv__Owner, !zelf.hasOverriden(selector: "__rtruediv__") {
      return owner.rtruediv(other)
    }

    return nil
  }

  internal static func __rxor__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rxor__Owner, !zelf.hasOverriden(selector: "__rxor__") {
      return owner.rxor(other)
    }

    return nil
  }

  internal static func __setattr__(_ zelf: PyObject, name: PyObject, value: PyObject?) -> PyResult<PyNone>? {
    if let owner = zelf as? __setattr__Owner, !zelf.hasOverriden(selector: "__setattr__") {
      return owner.setAttribute(name: name, value: value)
    }

    return nil
  }

  internal static func __setitem__(_ zelf: PyObject, at index: PyObject, to value: PyObject) -> PyResult<PyNone>? {
    if let owner = zelf as? __setitem__Owner, !zelf.hasOverriden(selector: "__setitem__") {
      return owner.setItem(at: index, to: value)
    }

    return nil
  }

  internal static func __str__(_ zelf: PyObject) -> PyResult<String>? {
    if let owner = zelf as? __str__Owner, !zelf.hasOverriden(selector: "__str__") {
      return owner.str()
    }

    return nil
  }

  internal static func __sub__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __sub__Owner, !zelf.hasOverriden(selector: "__sub__") {
      return owner.sub(other)
    }

    return nil
  }

  internal static func __subclasscheck__(_ zelf: PyObject, of object: PyObject) -> PyResult<Bool>? {
    if let owner = zelf as? __subclasscheck__Owner, !zelf.hasOverriden(selector: "__subclasscheck__") {
      return owner.isSubtype(of: object)
    }

    return nil
  }

  internal static func __truediv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __truediv__Owner, !zelf.hasOverriden(selector: "__truediv__") {
      return owner.truediv(other)
    }

    return nil
  }

  internal static func __trunc__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __trunc__Owner, !zelf.hasOverriden(selector: "__trunc__") {
      return owner.trunc()
    }

    return nil
  }

  internal static func __xor__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __xor__Owner, !zelf.hasOverriden(selector: "__xor__") {
      return owner.xor(other)
    }

    return nil
  }

  internal static func keys(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? keysOwner, !zelf.hasOverriden(selector: "keys") {
      return owner.keys()
    }

    return nil
  }
}
