import Core

// swiftlint:disable line_length
// swiftlint:disable opening_brace
// swiftlint:disable trailing_newline
// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable file_length

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// == What is this? ==
// Sometimes instead of doing slow Python dispatch we will use Swift protocols.
// For example: when user has an 'list' and ask for '__len__' we could lookup
// this method in MRO, create bound object and dispatch it.
// But this is a lot of work.
// We can also: check if this method was overriden ('list' can be subclassed),
// if not then we can go directly to our Swift implementation.
// We could do this for all of the common magic methods.

// == Why? ==
// REASON 1: Debugging (trust me, you don't want to debug raw Python dispatch)
//
// Even for simple 'len([])' will have:
// 1. Check if 'list' implements '__len__'
// 2. Create bound method that will wrap 'list.__len__' function
// 3. Call this method - it will (eventually) call 'PyList.__len__' in Swift
// Now imagine going through this in lldb.
//
// That's a lot of work for such a simple operation.
//
// With protocol dispatch we will:
// 1. Check if 'list' implements '__len__Owner'
// 2. Check user has not overriden '__len__'
// 3. Directly call 'PyList.__len__' in Swift
// In lldb this is: n (check protocol), n (check override), s (step into Swift method).
//
// REASON 2: Static calls during 'Py.initialize'
// This also allows us to call Python methods during 'Py.initialize',
// when not all of the types are yet fully initialized.
// For example when we have not yet added '__hash__' to 'str.__dict__'
// we can still call this method because:
// - 'str' confrms to '__hash__Owner' protocol
// - it does not override builtin 'str.__hash__' method

// == Is this bullet-proof? ==
// Not really.
// If you remove one of the builtin methods from a type, then static protocol
// conformance will still remain.
//
// But most of the time you can't do this:
// >>> del list.__len__
// Traceback (most recent call last):
//   File "<stdin>", line 1, in <module>
// TypeError: can't set attributes of built-in/extension type 'list'

// === Table of contents ===
// 1. Owner protocol definitions - protocols for each operation
// 2. func hasOverridenBuiltinMethod
// 3. Fast enum - try to call given function with protocol dispatch
// 4. Owner protocol conformance - this type supports given operation/protocol

// MARK: - Owner protocols

// This protocol is here only to check if we have consistent '__new__' signatures.
// It will not be used in 'Fast' dispatch.
private protocol __new__Owner {
  static func pyNew(type: PyType, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>
}

// This protocol is here only to check if we have consistent '__init__' signatures.
// It will not be used in 'Fast' dispatch.
private protocol __init__Owner {
  associatedtype Zelf: PyObject
  static func pyInit(zelf: Zelf, args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone>
}

// Special protocol to get '__dict__' property.
internal protocol __dict__Owner {
  func getDict() -> PyDict
}

private protocol __abs__Owner { func abs() -> PyObject }
private protocol __add__Owner { func add(_ other: PyObject) -> PyResult<PyObject> }
private protocol __and__Owner { func and(_ other: PyObject) -> PyResult<PyObject> }
private protocol __bool__Owner { func asBool() -> Bool }
private protocol __call__Owner { func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> }
private protocol __complex__Owner { func asComplex() -> PyObject }
private protocol __contains__Owner { func contains(_ element: PyObject) -> PyResult<Bool> }
private protocol __del__Owner { func del() -> PyResult<PyNone> }
private protocol __delitem__Owner { func delItem(at index: PyObject) -> PyResult<PyNone> }
private protocol __dir__Owner { func dir() -> PyResult<DirResult> }
private protocol __divmod__Owner { func divmod(_ other: PyObject) -> PyResult<PyObject> }
private protocol __eq__Owner { func isEqual(_ other: PyObject) -> CompareResult }
private protocol __float__Owner { func asFloat() -> PyResult<PyFloat> }
private protocol __floordiv__Owner { func floordiv(_ other: PyObject) -> PyResult<PyObject> }
private protocol __ge__Owner { func isGreaterEqual(_ other: PyObject) -> CompareResult }
private protocol __getattribute__Owner { func getAttribute(name: PyObject) -> PyResult<PyObject> }
private protocol __getitem__Owner { func getItem(at index: PyObject) -> PyResult<PyObject> }
private protocol __gt__Owner { func isGreater(_ other: PyObject) -> CompareResult }
private protocol __hash__Owner { func hash() -> HashResult }
private protocol __iadd__Owner { func iadd(_ other: PyObject) -> PyResult<PyObject> }
private protocol __iand__Owner { func iand(_ other: PyObject) -> PyResult<PyObject> }
private protocol __idivmod__Owner { func idivmod(_ other: PyObject) -> PyResult<PyObject> }
private protocol __ifloordiv__Owner { func ifloordiv(_ other: PyObject) -> PyResult<PyObject> }
private protocol __ilshift__Owner { func ilshift(_ other: PyObject) -> PyResult<PyObject> }
private protocol __imatmul__Owner { func imatmul(_ other: PyObject) -> PyResult<PyObject> }
private protocol __imod__Owner { func imod(_ other: PyObject) -> PyResult<PyObject> }
private protocol __imul__Owner { func imul(_ other: PyObject) -> PyResult<PyObject> }
private protocol __index__Owner { func asIndex() -> BigInt }
private protocol __instancecheck__Owner { func isType(of object: PyObject) -> Bool }
private protocol __invert__Owner { func invert() -> PyObject }
private protocol __ior__Owner { func ior(_ other: PyObject) -> PyResult<PyObject> }
private protocol __ipow__Owner { func ipow(_ other: PyObject) -> PyResult<PyObject> }
private protocol __irshift__Owner { func irshift(_ other: PyObject) -> PyResult<PyObject> }
private protocol __isabstractmethod__Owner { func isAbstractMethod() -> PyResult<Bool> }
private protocol __isub__Owner { func isub(_ other: PyObject) -> PyResult<PyObject> }
private protocol __iter__Owner { func iter() -> PyObject }
private protocol __itruediv__Owner { func itruediv(_ other: PyObject) -> PyResult<PyObject> }
private protocol __ixor__Owner { func ixor(_ other: PyObject) -> PyResult<PyObject> }
private protocol __le__Owner { func isLessEqual(_ other: PyObject) -> CompareResult }
private protocol __len__Owner { func getLength() -> BigInt }
private protocol __lshift__Owner { func lshift(_ other: PyObject) -> PyResult<PyObject> }
private protocol __lt__Owner { func isLess(_ other: PyObject) -> CompareResult }
private protocol __matmul__Owner { func matmul(_ other: PyObject) -> PyResult<PyObject> }
private protocol __mod__Owner { func mod(_ other: PyObject) -> PyResult<PyObject> }
private protocol __mul__Owner { func mul(_ other: PyObject) -> PyResult<PyObject> }
private protocol __ne__Owner { func isNotEqual(_ other: PyObject) -> CompareResult }
private protocol __neg__Owner { func negative() -> PyObject }
private protocol __next__Owner { func next() -> PyResult<PyObject> }
private protocol __or__Owner { func or(_ other: PyObject) -> PyResult<PyObject> }
private protocol __pos__Owner { func positive() -> PyObject }
private protocol __pow__Owner { func pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject> }
private protocol __radd__Owner { func radd(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rand__Owner { func rand(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rdivmod__Owner { func rdivmod(_ other: PyObject) -> PyResult<PyObject> }
private protocol __repr__Owner { func repr() -> PyResult<String> }
private protocol __reversed__Owner { func reversed() -> PyObject }
private protocol __rfloordiv__Owner { func rfloordiv(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rlshift__Owner { func rlshift(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rmatmul__Owner { func rmatmul(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rmod__Owner { func rmod(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rmul__Owner { func rmul(_ other: PyObject) -> PyResult<PyObject> }
private protocol __ror__Owner { func ror(_ other: PyObject) -> PyResult<PyObject> }
private protocol __round__Owner { func round(nDigits: PyObject?) -> PyResult<PyObject> }
private protocol __rpow__Owner { func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> }
private protocol __rrshift__Owner { func rrshift(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rshift__Owner { func rshift(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rsub__Owner { func rsub(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rtruediv__Owner { func rtruediv(_ other: PyObject) -> PyResult<PyObject> }
private protocol __rxor__Owner { func rxor(_ other: PyObject) -> PyResult<PyObject> }
private protocol __setattr__Owner { func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> }
private protocol __setitem__Owner { func setItem(at index: PyObject, to value: PyObject) -> PyResult<PyNone> }
private protocol __str__Owner { func str() -> PyResult<String> }
private protocol __sub__Owner { func sub(_ other: PyObject) -> PyResult<PyObject> }
private protocol __subclasscheck__Owner { func isSubtype(of object: PyObject) -> PyResult<Bool> }
private protocol __truediv__Owner { func truediv(_ other: PyObject) -> PyResult<PyObject> }
private protocol __trunc__Owner { func trunc() -> PyObject }
private protocol __xor__Owner { func xor(_ other: PyObject) -> PyResult<PyObject> }
private protocol keysOwner { func keys() -> PyObject }

// MARK: - Has overriden

/// Check if the user has overriden given method.
private func hasOverridenBuiltinMethod(
  object: PyObject,
  selector: IdString
) -> Bool {
  // Soo... we could actually check if if the user has overriden builtin method:
  // 1. Get method from MRO: let lookup = type.lookupWithType(name: selector)
  // 2. Check if type is builtin/heap type: lookup.type.isHeapType
  //    - If builtin: user has not overriden
  //    - If heap: user has overriden
  //
  // Or we can just assume that all heap types override.
  // In most of the cases it will not be true (how ofter do you see '__len__'
  // overriden on a list subclass?), but it does not matter.
  //
  // Just a reminder: heap type - type created by user with 'class' statement.

  let type = object.type
  let isHeapType = type.isHeapType
  return isHeapType
}

// MARK: - Fast

internal enum Fast {

  internal static func __abs__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __abs__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__abs__) {
      return owner.abs()
    }

    return nil
  }

  internal static func __add__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __add__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__add__) {
      return owner.add(other)
    }

    return nil
  }

  internal static func __and__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __and__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__and__) {
      return owner.and(other)
    }

    return nil
  }

  internal static func __bool__(_ zelf: PyObject) -> Bool? {
    if let owner = zelf as? __bool__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__bool__) {
      return owner.asBool()
    }

    return nil
  }

  internal static func __call__(_ zelf: PyObject, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>? {
    if let owner = zelf as? __call__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__call__) {
      return owner.call(args: args, kwargs: kwargs)
    }

    return nil
  }

  internal static func __complex__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __complex__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__complex__) {
      return owner.asComplex()
    }

    return nil
  }

  internal static func __contains__(_ zelf: PyObject, _ element: PyObject) -> PyResult<Bool>? {
    if let owner = zelf as? __contains__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__contains__) {
      return owner.contains(element)
    }

    return nil
  }

  internal static func __del__(_ zelf: PyObject) -> PyResult<PyNone>? {
    if let owner = zelf as? __del__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__del__) {
      return owner.del()
    }

    return nil
  }

  internal static func __delitem__(_ zelf: PyObject, at index: PyObject) -> PyResult<PyNone>? {
    if let owner = zelf as? __delitem__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__delitem__) {
      return owner.delItem(at: index)
    }

    return nil
  }

  internal static func __dir__(_ zelf: PyObject) -> PyResult<DirResult>? {
    if let owner = zelf as? __dir__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__dir__) {
      return owner.dir()
    }

    return nil
  }

  internal static func __divmod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __divmod__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__divmod__) {
      return owner.divmod(other)
    }

    return nil
  }

  internal static func __eq__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __eq__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__eq__) {
      return owner.isEqual(other)
    }

    return nil
  }

  internal static func __float__(_ zelf: PyObject) -> PyResult<PyFloat>? {
    if let owner = zelf as? __float__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__float__) {
      return owner.asFloat()
    }

    return nil
  }

  internal static func __floordiv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __floordiv__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__floordiv__) {
      return owner.floordiv(other)
    }

    return nil
  }

  internal static func __ge__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __ge__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__ge__) {
      return owner.isGreaterEqual(other)
    }

    return nil
  }

  internal static func __getattribute__(_ zelf: PyObject, name: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __getattribute__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__getattribute__) {
      return owner.getAttribute(name: name)
    }

    return nil
  }

  internal static func __getitem__(_ zelf: PyObject, at index: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __getitem__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__getitem__) {
      return owner.getItem(at: index)
    }

    return nil
  }

  internal static func __gt__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __gt__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__gt__) {
      return owner.isGreater(other)
    }

    return nil
  }

  internal static func __hash__(_ zelf: PyObject) -> HashResult? {
    if let owner = zelf as? __hash__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__hash__) {
      return owner.hash()
    }

    return nil
  }

  internal static func __iadd__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __iadd__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__iadd__) {
      return owner.iadd(other)
    }

    return nil
  }

  internal static func __iand__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __iand__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__iand__) {
      return owner.iand(other)
    }

    return nil
  }

  internal static func __idivmod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __idivmod__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__idivmod__) {
      return owner.idivmod(other)
    }

    return nil
  }

  internal static func __ifloordiv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ifloordiv__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__ifloordiv__) {
      return owner.ifloordiv(other)
    }

    return nil
  }

  internal static func __ilshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ilshift__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__ilshift__) {
      return owner.ilshift(other)
    }

    return nil
  }

  internal static func __imatmul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __imatmul__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__imatmul__) {
      return owner.imatmul(other)
    }

    return nil
  }

  internal static func __imod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __imod__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__imod__) {
      return owner.imod(other)
    }

    return nil
  }

  internal static func __imul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __imul__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__imul__) {
      return owner.imul(other)
    }

    return nil
  }

  internal static func __index__(_ zelf: PyObject) -> BigInt? {
    if let owner = zelf as? __index__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__index__) {
      return owner.asIndex()
    }

    return nil
  }

  internal static func __instancecheck__(_ zelf: PyObject, of object: PyObject) -> Bool? {
    if let owner = zelf as? __instancecheck__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__instancecheck__) {
      return owner.isType(of: object)
    }

    return nil
  }

  internal static func __invert__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __invert__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__invert__) {
      return owner.invert()
    }

    return nil
  }

  internal static func __ior__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ior__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__ior__) {
      return owner.ior(other)
    }

    return nil
  }

  internal static func __ipow__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ipow__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__ipow__) {
      return owner.ipow(other)
    }

    return nil
  }

  internal static func __irshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __irshift__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__irshift__) {
      return owner.irshift(other)
    }

    return nil
  }

  internal static func __isabstractmethod__(_ zelf: PyObject) -> PyResult<Bool>? {
    if let owner = zelf as? __isabstractmethod__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__isabstractmethod__) {
      return owner.isAbstractMethod()
    }

    return nil
  }

  internal static func __isub__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __isub__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__isub__) {
      return owner.isub(other)
    }

    return nil
  }

  internal static func __iter__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __iter__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__iter__) {
      return owner.iter()
    }

    return nil
  }

  internal static func __itruediv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __itruediv__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__itruediv__) {
      return owner.itruediv(other)
    }

    return nil
  }

  internal static func __ixor__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ixor__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__ixor__) {
      return owner.ixor(other)
    }

    return nil
  }

  internal static func __le__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __le__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__le__) {
      return owner.isLessEqual(other)
    }

    return nil
  }

  internal static func __len__(_ zelf: PyObject) -> BigInt? {
    if let owner = zelf as? __len__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__len__) {
      return owner.getLength()
    }

    return nil
  }

  internal static func __lshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __lshift__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__lshift__) {
      return owner.lshift(other)
    }

    return nil
  }

  internal static func __lt__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __lt__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__lt__) {
      return owner.isLess(other)
    }

    return nil
  }

  internal static func __matmul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __matmul__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__matmul__) {
      return owner.matmul(other)
    }

    return nil
  }

  internal static func __mod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __mod__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__mod__) {
      return owner.mod(other)
    }

    return nil
  }

  internal static func __mul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __mul__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__mul__) {
      return owner.mul(other)
    }

    return nil
  }

  internal static func __ne__(_ zelf: PyObject, _ other: PyObject) -> CompareResult? {
    if let owner = zelf as? __ne__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__ne__) {
      return owner.isNotEqual(other)
    }

    return nil
  }

  internal static func __neg__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __neg__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__neg__) {
      return owner.negative()
    }

    return nil
  }

  internal static func __next__(_ zelf: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __next__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__next__) {
      return owner.next()
    }

    return nil
  }

  internal static func __or__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __or__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__or__) {
      return owner.or(other)
    }

    return nil
  }

  internal static func __pos__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __pos__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__pos__) {
      return owner.positive()
    }

    return nil
  }

  internal static func __pow__(_ zelf: PyObject, exp: PyObject, mod: PyObject?) -> PyResult<PyObject>? {
    if let owner = zelf as? __pow__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__pow__) {
      return owner.pow(exp: exp, mod: mod)
    }

    return nil
  }

  internal static func __radd__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __radd__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__radd__) {
      return owner.radd(other)
    }

    return nil
  }

  internal static func __rand__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rand__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rand__) {
      return owner.rand(other)
    }

    return nil
  }

  internal static func __rdivmod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rdivmod__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rdivmod__) {
      return owner.rdivmod(other)
    }

    return nil
  }

  internal static func __repr__(_ zelf: PyObject) -> PyResult<String>? {
    if let owner = zelf as? __repr__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__repr__) {
      return owner.repr()
    }

    return nil
  }

  internal static func __reversed__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __reversed__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__reversed__) {
      return owner.reversed()
    }

    return nil
  }

  internal static func __rfloordiv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rfloordiv__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rfloordiv__) {
      return owner.rfloordiv(other)
    }

    return nil
  }

  internal static func __rlshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rlshift__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rlshift__) {
      return owner.rlshift(other)
    }

    return nil
  }

  internal static func __rmatmul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rmatmul__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rmatmul__) {
      return owner.rmatmul(other)
    }

    return nil
  }

  internal static func __rmod__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rmod__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rmod__) {
      return owner.rmod(other)
    }

    return nil
  }

  internal static func __rmul__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rmul__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rmul__) {
      return owner.rmul(other)
    }

    return nil
  }

  internal static func __ror__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __ror__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__ror__) {
      return owner.ror(other)
    }

    return nil
  }

  internal static func __round__(_ zelf: PyObject, nDigits: PyObject?) -> PyResult<PyObject>? {
    if let owner = zelf as? __round__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__round__) {
      return owner.round(nDigits: nDigits)
    }

    return nil
  }

  internal static func __rpow__(_ zelf: PyObject, base: PyObject, mod: PyObject?) -> PyResult<PyObject>? {
    if let owner = zelf as? __rpow__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rpow__) {
      return owner.rpow(base: base, mod: mod)
    }

    return nil
  }

  internal static func __rrshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rrshift__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rrshift__) {
      return owner.rrshift(other)
    }

    return nil
  }

  internal static func __rshift__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rshift__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rshift__) {
      return owner.rshift(other)
    }

    return nil
  }

  internal static func __rsub__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rsub__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rsub__) {
      return owner.rsub(other)
    }

    return nil
  }

  internal static func __rtruediv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rtruediv__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rtruediv__) {
      return owner.rtruediv(other)
    }

    return nil
  }

  internal static func __rxor__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __rxor__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__rxor__) {
      return owner.rxor(other)
    }

    return nil
  }

  internal static func __setattr__(_ zelf: PyObject, name: PyObject, value: PyObject?) -> PyResult<PyNone>? {
    if let owner = zelf as? __setattr__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__setattr__) {
      return owner.setAttribute(name: name, value: value)
    }

    return nil
  }

  internal static func __setitem__(_ zelf: PyObject, at index: PyObject, to value: PyObject) -> PyResult<PyNone>? {
    if let owner = zelf as? __setitem__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__setitem__) {
      return owner.setItem(at: index, to: value)
    }

    return nil
  }

  internal static func __str__(_ zelf: PyObject) -> PyResult<String>? {
    if let owner = zelf as? __str__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__str__) {
      return owner.str()
    }

    return nil
  }

  internal static func __sub__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __sub__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__sub__) {
      return owner.sub(other)
    }

    return nil
  }

  internal static func __subclasscheck__(_ zelf: PyObject, of object: PyObject) -> PyResult<Bool>? {
    if let owner = zelf as? __subclasscheck__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__subclasscheck__) {
      return owner.isSubtype(of: object)
    }

    return nil
  }

  internal static func __truediv__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __truediv__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__truediv__) {
      return owner.truediv(other)
    }

    return nil
  }

  internal static func __trunc__(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? __trunc__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__trunc__) {
      return owner.trunc()
    }

    return nil
  }

  internal static func __xor__(_ zelf: PyObject, _ other: PyObject) -> PyResult<PyObject>? {
    if let owner = zelf as? __xor__Owner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .__xor__) {
      return owner.xor(other)
    }

    return nil
  }

  internal static func keys(_ zelf: PyObject) -> PyObject? {
    if let owner = zelf as? keysOwner,
       !hasOverridenBuiltinMethod(object: zelf, selector: .keys) {
      return owner.keys()
    }

    return nil
  }
}

// MARK: - Conformance

// PyBool does not add any new protocols to PyInt
extension PyBool { }

extension PyBuiltinFunction:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __call__Owner
{ }

extension PyBuiltinMethod:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __call__Owner
{ }

extension PyByteArray:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner,
  __iter__Owner,
  __setitem__Owner,
  __delitem__Owner,
  __init__Owner,
  __new__Owner
{ }

extension PyByteArrayIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyBytes:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner,
  __iter__Owner,
  __new__Owner
{ }

extension PyBytesIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyCallableIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

extension PyCell:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __repr__Owner,
  __getattribute__Owner
{ }

extension PyClassMethod:
  __dict__Owner,
  __isabstractmethod__Owner,
  __init__Owner,
  __new__Owner
{ }

extension PyCode:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner
{ }

extension PyComplex:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __bool__Owner,
  __float__Owner,
  __getattribute__Owner,
  __pos__Owner,
  __neg__Owner,
  __abs__Owner,
  __add__Owner,
  __radd__Owner,
  __sub__Owner,
  __rsub__Owner,
  __mul__Owner,
  __rmul__Owner,
  __pow__Owner,
  __rpow__Owner,
  __truediv__Owner,
  __rtruediv__Owner,
  __floordiv__Owner,
  __rfloordiv__Owner,
  __mod__Owner,
  __rmod__Owner,
  __divmod__Owner,
  __rdivmod__Owner,
  __new__Owner
{ }

extension PyDict:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __getitem__Owner,
  __setitem__Owner,
  __delitem__Owner,
  __contains__Owner,
  __iter__Owner,
  keysOwner,
  __new__Owner,
  __init__Owner
{ }

extension PyDictItemIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyDictItems:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __iter__Owner,
  __new__Owner
{ }

extension PyDictKeyIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyDictKeys:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __iter__Owner,
  __new__Owner
{ }

extension PyDictValueIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyDictValues:
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __iter__Owner
{ }

extension PyEllipsis:
  __repr__Owner,
  __getattribute__Owner,
  __new__Owner
{ }

extension PyEnumerate:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyFilter:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyFloat:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __bool__Owner,
  __float__Owner,
  __getattribute__Owner,
  __pos__Owner,
  __neg__Owner,
  __abs__Owner,
  __add__Owner,
  __radd__Owner,
  __sub__Owner,
  __rsub__Owner,
  __mul__Owner,
  __rmul__Owner,
  __pow__Owner,
  __rpow__Owner,
  __truediv__Owner,
  __rtruediv__Owner,
  __floordiv__Owner,
  __rfloordiv__Owner,
  __mod__Owner,
  __rmod__Owner,
  __divmod__Owner,
  __rdivmod__Owner,
  __round__Owner,
  __trunc__Owner,
  __new__Owner
{ }

extension PyFrame:
  __repr__Owner,
  __getattribute__Owner,
  __setattr__Owner
{ }

extension PyFrozenSet:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __and__Owner,
  __rand__Owner,
  __or__Owner,
  __ror__Owner,
  __xor__Owner,
  __rxor__Owner,
  __sub__Owner,
  __rsub__Owner,
  __iter__Owner,
  __new__Owner
{ }

extension PyFunction:
  __dict__Owner,
  __repr__Owner,
  __call__Owner
{ }

extension PyInt:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __bool__Owner,
  __float__Owner,
  __index__Owner,
  __getattribute__Owner,
  __pos__Owner,
  __neg__Owner,
  __abs__Owner,
  __trunc__Owner,
  __add__Owner,
  __radd__Owner,
  __sub__Owner,
  __rsub__Owner,
  __mul__Owner,
  __rmul__Owner,
  __pow__Owner,
  __rpow__Owner,
  __truediv__Owner,
  __rtruediv__Owner,
  __floordiv__Owner,
  __rfloordiv__Owner,
  __mod__Owner,
  __rmod__Owner,
  __divmod__Owner,
  __rdivmod__Owner,
  __lshift__Owner,
  __rlshift__Owner,
  __rshift__Owner,
  __rrshift__Owner,
  __and__Owner,
  __rand__Owner,
  __or__Owner,
  __ror__Owner,
  __xor__Owner,
  __rxor__Owner,
  __invert__Owner,
  __round__Owner,
  __new__Owner
{ }

extension PyIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

extension PyList:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __setitem__Owner,
  __delitem__Owner,
  __iter__Owner,
  __reversed__Owner,
  __add__Owner,
  __iadd__Owner,
  __mul__Owner,
  __rmul__Owner,
  __imul__Owner,
  __new__Owner,
  __init__Owner
{ }

extension PyListIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyListReverseIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyMap:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyMethod:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __repr__Owner,
  __hash__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __call__Owner
{ }

extension PyModule:
  __dict__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __dir__Owner,
  __new__Owner,
  __init__Owner
{ }

extension PyNamespace:
  __dict__Owner,
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __init__Owner
{ }

extension PyNone:
  __repr__Owner,
  __bool__Owner,
  __getattribute__Owner,
  __new__Owner
{ }

extension PyNotImplemented:
  __repr__Owner,
  __new__Owner
{ }

extension PyProperty:
  __getattribute__Owner,
  __new__Owner,
  __init__Owner
{ }

extension PyRange:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __bool__Owner,
  __len__Owner,
  __getattribute__Owner,
  __contains__Owner,
  __getitem__Owner,
  __reversed__Owner,
  __iter__Owner,
  __new__Owner
{ }

extension PyRangeIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyReversed:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PySet:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __and__Owner,
  __rand__Owner,
  __or__Owner,
  __ror__Owner,
  __xor__Owner,
  __rxor__Owner,
  __sub__Owner,
  __rsub__Owner,
  __iter__Owner,
  __new__Owner,
  __init__Owner
{ }

extension PySetIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PySlice:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __new__Owner
{ }

extension PyStaticMethod:
  __dict__Owner,
  __isabstractmethod__Owner,
  __init__Owner,
  __new__Owner
{ }

extension PyString:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner,
  __iter__Owner,
  __new__Owner
{ }

extension PyStringIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PySuper:
  __repr__Owner,
  __getattribute__Owner,
  __new__Owner,
  __init__Owner
{ }

extension PyTextFile:
  __repr__Owner,
  __del__Owner
{ }

extension PyTuple:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __iter__Owner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner,
  __new__Owner
{ }

extension PyTupleIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

extension PyType:
  __dict__Owner,
  __repr__Owner,
  __subclasscheck__Owner,
  __instancecheck__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __dir__Owner,
  __call__Owner,
  __new__Owner,
  __init__Owner
{ }

extension PyZip:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner,
  __new__Owner
{ }

// PyArithmeticError does not add any new protocols to PyException
extension PyArithmeticError { }

// PyAssertionError does not add any new protocols to PyException
extension PyAssertionError { }

// PyAttributeError does not add any new protocols to PyException
extension PyAttributeError { }

extension PyBaseException:
  __dict__Owner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __new__Owner,
  __init__Owner
{ }

// PyBlockingIOError does not add any new protocols to PyOSError
extension PyBlockingIOError { }

// PyBrokenPipeError does not add any new protocols to PyConnectionError
extension PyBrokenPipeError { }

// PyBufferError does not add any new protocols to PyException
extension PyBufferError { }

// PyBytesWarning does not add any new protocols to PyWarning
extension PyBytesWarning { }

// PyChildProcessError does not add any new protocols to PyOSError
extension PyChildProcessError { }

// PyConnectionAbortedError does not add any new protocols to PyConnectionError
extension PyConnectionAbortedError { }

// PyConnectionError does not add any new protocols to PyOSError
extension PyConnectionError { }

// PyConnectionRefusedError does not add any new protocols to PyConnectionError
extension PyConnectionRefusedError { }

// PyConnectionResetError does not add any new protocols to PyConnectionError
extension PyConnectionResetError { }

// PyDeprecationWarning does not add any new protocols to PyWarning
extension PyDeprecationWarning { }

// PyEOFError does not add any new protocols to PyException
extension PyEOFError { }

// PyException does not add any new protocols to PyBaseException
extension PyException { }

// PyFileExistsError does not add any new protocols to PyOSError
extension PyFileExistsError { }

// PyFileNotFoundError does not add any new protocols to PyOSError
extension PyFileNotFoundError { }

// PyFloatingPointError does not add any new protocols to PyArithmeticError
extension PyFloatingPointError { }

// PyFutureWarning does not add any new protocols to PyWarning
extension PyFutureWarning { }

// PyGeneratorExit does not add any new protocols to PyBaseException
extension PyGeneratorExit { }

// PyImportError does not add any new protocols to PyException
extension PyImportError { }

// PyImportWarning does not add any new protocols to PyWarning
extension PyImportWarning { }

// PyIndentationError does not add any new protocols to PySyntaxError
extension PyIndentationError { }

// PyIndexError does not add any new protocols to PyLookupError
extension PyIndexError { }

// PyInterruptedError does not add any new protocols to PyOSError
extension PyInterruptedError { }

// PyIsADirectoryError does not add any new protocols to PyOSError
extension PyIsADirectoryError { }

// PyKeyError does not add any new protocols to PyLookupError
extension PyKeyError { }

// PyKeyboardInterrupt does not add any new protocols to PyBaseException
extension PyKeyboardInterrupt { }

// PyLookupError does not add any new protocols to PyException
extension PyLookupError { }

// PyMemoryError does not add any new protocols to PyException
extension PyMemoryError { }

// PyModuleNotFoundError does not add any new protocols to PyImportError
extension PyModuleNotFoundError { }

// PyNameError does not add any new protocols to PyException
extension PyNameError { }

// PyNotADirectoryError does not add any new protocols to PyOSError
extension PyNotADirectoryError { }

// PyNotImplementedError does not add any new protocols to PyRuntimeError
extension PyNotImplementedError { }

// PyOSError does not add any new protocols to PyException
extension PyOSError { }

// PyOverflowError does not add any new protocols to PyArithmeticError
extension PyOverflowError { }

// PyPendingDeprecationWarning does not add any new protocols to PyWarning
extension PyPendingDeprecationWarning { }

// PyPermissionError does not add any new protocols to PyOSError
extension PyPermissionError { }

// PyProcessLookupError does not add any new protocols to PyOSError
extension PyProcessLookupError { }

// PyRecursionError does not add any new protocols to PyRuntimeError
extension PyRecursionError { }

// PyReferenceError does not add any new protocols to PyException
extension PyReferenceError { }

// PyResourceWarning does not add any new protocols to PyWarning
extension PyResourceWarning { }

// PyRuntimeError does not add any new protocols to PyException
extension PyRuntimeError { }

// PyRuntimeWarning does not add any new protocols to PyWarning
extension PyRuntimeWarning { }

// PyStopAsyncIteration does not add any new protocols to PyException
extension PyStopAsyncIteration { }

// PyStopIteration does not add any new protocols to PyException
extension PyStopIteration { }

// PySyntaxError does not add any new protocols to PyException
extension PySyntaxError { }

// PySyntaxWarning does not add any new protocols to PyWarning
extension PySyntaxWarning { }

// PySystemError does not add any new protocols to PyException
extension PySystemError { }

// PySystemExit does not add any new protocols to PyBaseException
extension PySystemExit { }

// PyTabError does not add any new protocols to PyIndentationError
extension PyTabError { }

// PyTimeoutError does not add any new protocols to PyOSError
extension PyTimeoutError { }

// PyTypeError does not add any new protocols to PyException
extension PyTypeError { }

// PyUnboundLocalError does not add any new protocols to PyNameError
extension PyUnboundLocalError { }

// PyUnicodeDecodeError does not add any new protocols to PyUnicodeError
extension PyUnicodeDecodeError { }

// PyUnicodeEncodeError does not add any new protocols to PyUnicodeError
extension PyUnicodeEncodeError { }

// PyUnicodeError does not add any new protocols to PyValueError
extension PyUnicodeError { }

// PyUnicodeTranslateError does not add any new protocols to PyUnicodeError
extension PyUnicodeTranslateError { }

// PyUnicodeWarning does not add any new protocols to PyWarning
extension PyUnicodeWarning { }

// PyUserWarning does not add any new protocols to PyWarning
extension PyUserWarning { }

// PyValueError does not add any new protocols to PyException
extension PyValueError { }

// PyWarning does not add any new protocols to PyException
extension PyWarning { }

// PyZeroDivisionError does not add any new protocols to PyArithmeticError
extension PyZeroDivisionError { }

