// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// A lot of the code in this file was generated using:
// './Scripts/generate-builtins-binary.py'

// swiftlint:disable file_length

// MARK: - Abstract

/// Basically a template for binary operations.
/// See `Builtins+Compare` for reasoning why we do it this way.
private protocol BinaryOp {

  /// Operator used to invoke given binary operation, for example '+'.
  /// Used for error messages.
  static var op: String { get }
  /// Operator used to invoke given binary operation, for example '+='.
  /// Used for error messages.
  static var inPlaceOp: String { get }

  /// Python selector, for example `__add__`.
  static var selector: String { get }
  /// Python selector for reverse operation.
  /// For `__add__` it is `__radd__`.
  static var reverseSelector: String { get }
  /// Python selector for in-place operation.
  /// For `__add__` it is `__iadd__`.
  static var inPlaceSelector: String { get }

  /// Call op with fast protocol dispatch.
  static func callFastOp(left: PyObject,
                         right: PyObject) -> PyResultOrNot<PyObject>
  /// Call reverse op with fast protocol dispatch.
  /// For `__add__` it should call `__radd__`.
  static func callFastReverse(left: PyObject,
                              right: PyObject) -> PyResultOrNot<PyObject>
  /// Call in-place op with fast protocol dispatch.
  /// For `__add__` it should call `__iadd__`.
  static func callFastInPlace(left: PyObject,
                              right: PyObject) -> PyResultOrNot<PyObject>
}

extension BinaryOp {

  /// static PyObject *
  /// binary_op1(PyObject *v, PyObject *w, const int op_slot)
  /// static PyObject *
  /// binary_op(PyObject *v, PyObject *w, const int op_slot, const char *op_name)
  /// define SLOT1BINFULL(FUNCNAME, TESTFUNC, SLOTNAME, OPSTR, ROPSTR)
  fileprivate static func call(left: PyObject,
                               right: PyObject) -> PyResult<PyObject> {
    switch callInner(left: left, right: right, operation: op) {
    case .value(let result):
      return .value(result)
    case .error(let e):
      return .error(e)
    case .notImplemented:
      let lt = left.typeName
      let rt = right.typeName
      var msg = "unsupported operand type(s) for \(op): '\(lt)' and '\(rt)'."

      // For C++ programmers who try to `print << 'Elsa'`:
      if let fn = left as? PyBuiltinFunction, fn.name == "print", Self.op == "<<" {
        msg += " Did you mean \"print(<message>, file=<output_stream>)\"?"
      }

      return .typeError(msg)
    }
  }

  fileprivate static func callInPlace(left: PyObject,
                                      right: PyObject) -> PyResult<PyObject> {
    let builtins = left.context.builtins

    // Try fast protocol-based dispach
    switch callFastInPlace(left: left, right: right) {
    case .value(let result):
      if !(result is PyNotImplemented) {
        return .value(result)
      }
    case .notImplemented:
      break // Try other options...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch builtins.callMethod(on: left, selector: inPlaceSelector, arg: right) {
    case .value(let result):
      if !(result is PyNotImplemented) {
        return .value(result)
      }
    case .noSuchMethod,
         .notImplemented:
      break // Try other options...
    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }

    // Try standard operation, for example '+'
    switch callInner(left: left, right: right, operation: op) {
    case .value(let result):
      return .value(result)
    case .error(let e):
      return .error(e)
    case .notImplemented:
      let lt = left.typeName
      let rt = right.typeName
      let msg = "unsupported operand type(s) for \(inPlaceOp): '\(lt)' and '\(rt)'."
      return .typeError(msg)
    }
  }

  /// static PyObject *
  /// binary_op1(PyObject *v, PyObject *w, const int op_slot)
  /// static PyObject *
  /// binary_op(PyObject *v, PyObject *w, const int op_slot, const char *op_name)
  fileprivate static func callInner(left: PyObject,
                                    right: PyObject,
                                    operation: String) -> PyResultOrNot<PyObject> {
    var checkedReverse = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReverse = true

      switch callReverse(left: left, right: right) {
      case .value(let result): return .value(result)
      case .error(let e): return .error(e)
      case .notImplemented: break
      }
    }

    // Try left `op` right (default path)
    switch callOp(left: left, right: right) {
    case .value(let result): return .value(result)
    case .error(let e): return .error(e)
    case .notImplemented: break
    }

    // Try reverse on right
    if !checkedReverse {
      switch callReverse(left: left, right: right) {
      case .value(let result): return .value(result)
      case .error(let e): return .error(e)
      case .notImplemented: break
      }
    }

    // No hope left! We are doomed!
    return .notImplemented
  }

  private static func callOp(left: PyObject,
                             right: PyObject) -> PyResultOrNot<PyObject> {
    let builtins = left.context.builtins

    // Try fast protocol-based dispach
    switch callFastOp(left: left, right: right) {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .notImplemented:
      break // Try other options...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch builtins.callMethod(on: left, selector: selector, arg: right) {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .noSuchMethod,
         .notImplemented:
      return .notImplemented
    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }
  }

  private static func callReverse(left: PyObject,
                                  right: PyObject) -> PyResultOrNot<PyObject> {
    let builtins = left.context.builtins

    // Try fast protocol-based dispach
    switch callFastReverse(left: left, right: right) {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .notImplemented:
      break // Try other options...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch builtins.callMethod(on: right, selector: reverseSelector, arg: left) {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .noSuchMethod,
         .notImplemented:
      return .notImplemented
    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }
  }
}

// MARK: - Builtins

extension Builtins {

  // MARK: - Add

  private struct AddOp: BinaryOp {

    fileprivate static let op = "+"
    fileprivate static let inPlaceOp = "+="
    fileprivate static let selector = "__add__"
    fileprivate static let reverseSelector = "__radd__"
    fileprivate static let inPlaceSelector = "__iadd__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __add__Owner {
        return owner.add(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __radd__Owner {
        return owner.radd(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __iadd__Owner {
        return owner.iadd(right)
      }
      return .notImplemented
    }
  }

  public func add(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AddOp.call(left: left, right: right)
  }

  public func addInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AddOp.callInPlace(left: left, right: right)
  }

  // MARK: - Sub

  private struct SubOp: BinaryOp {

    fileprivate static let op = "-"
    fileprivate static let inPlaceOp = "-="
    fileprivate static let selector = "__sub__"
    fileprivate static let reverseSelector = "__rsub__"
    fileprivate static let inPlaceSelector = "__isub__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __sub__Owner {
        return owner.sub(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rsub__Owner {
        return owner.rsub(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __isub__Owner {
        return owner.isub(right)
      }
      return .notImplemented
    }
  }

  public func sub(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return SubOp.call(left: left, right: right)
  }

  public func subInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return SubOp.callInPlace(left: left, right: right)
  }

  // MARK: - Mul

  private struct MulOp: BinaryOp {

    fileprivate static let op = "*"
    fileprivate static let inPlaceOp = "*="
    fileprivate static let selector = "__mul__"
    fileprivate static let reverseSelector = "__rmul__"
    fileprivate static let inPlaceSelector = "__imul__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __mul__Owner {
        return owner.mul(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rmul__Owner {
        return owner.rmul(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __imul__Owner {
        return owner.imul(right)
      }
      return .notImplemented
    }
  }

  public func mul(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MulOp.call(left: left, right: right)
  }

  public func mulInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MulOp.callInPlace(left: left, right: right)
  }

  // MARK: - Matmul

  private struct MatmulOp: BinaryOp {

    fileprivate static let op = "@"
    fileprivate static let inPlaceOp = "@="
    fileprivate static let selector = "__matmul__"
    fileprivate static let reverseSelector = "__rmatmul__"
    fileprivate static let inPlaceSelector = "__imatmul__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __matmul__Owner {
        return owner.matmul(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rmatmul__Owner {
        return owner.rmatmul(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __imatmul__Owner {
        return owner.imatmul(right)
      }
      return .notImplemented
    }
  }

  public func matmul(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MatmulOp.call(left: left, right: right)
  }

  public func matmulInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MatmulOp.callInPlace(left: left, right: right)
  }

  // MARK: - Truediv

  private struct TruedivOp: BinaryOp {

    fileprivate static let op = "/"
    fileprivate static let inPlaceOp = "/="
    fileprivate static let selector = "__truediv__"
    fileprivate static let reverseSelector = "__rtruediv__"
    fileprivate static let inPlaceSelector = "__itruediv__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __truediv__Owner {
        return owner.truediv(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rtruediv__Owner {
        return owner.rtruediv(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __itruediv__Owner {
        return owner.itruediv(right)
      }
      return .notImplemented
    }
  }

  public func truediv(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return TruedivOp.call(left: left, right: right)
  }

  public func truedivInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return TruedivOp.callInPlace(left: left, right: right)
  }

  // MARK: - Floordiv

  private struct FloordivOp: BinaryOp {

    fileprivate static let op = "//"
    fileprivate static let inPlaceOp = "//="
    fileprivate static let selector = "__floordiv__"
    fileprivate static let reverseSelector = "__rfloordiv__"
    fileprivate static let inPlaceSelector = "__ifloordiv__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __floordiv__Owner {
        return owner.floordiv(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rfloordiv__Owner {
        return owner.rfloordiv(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __ifloordiv__Owner {
        return owner.ifloordiv(right)
      }
      return .notImplemented
    }
  }

  public func floordiv(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return FloordivOp.call(left: left, right: right)
  }

  public func floordivInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return FloordivOp.callInPlace(left: left, right: right)
  }

  // MARK: - Mod

  private struct ModOp: BinaryOp {

    fileprivate static let op = "%"
    fileprivate static let inPlaceOp = "%="
    fileprivate static let selector = "__mod__"
    fileprivate static let reverseSelector = "__rmod__"
    fileprivate static let inPlaceSelector = "__imod__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __mod__Owner {
        return owner.mod(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rmod__Owner {
        return owner.rmod(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __imod__Owner {
        return owner.imod(right)
      }
      return .notImplemented
    }
  }

  public func mod(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return ModOp.call(left: left, right: right)
  }

  public func modInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return ModOp.callInPlace(left: left, right: right)
  }

  // MARK: - Divmod

  private struct DivmodOp: BinaryOp {

    fileprivate static let op = "divmod()"
    fileprivate static let inPlaceOp = "divmod()="
    fileprivate static let selector = "__divmod__"
    fileprivate static let reverseSelector = "__rdivmod__"
    fileprivate static let inPlaceSelector = "__idivmod__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __divmod__Owner {
        return owner.divmod(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rdivmod__Owner {
        return owner.rdivmod(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __idivmod__Owner {
        return owner.idivmod(right)
      }
      return .notImplemented
    }
  }

  public func divmod(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return DivmodOp.call(left: left, right: right)
  }

  // `divmod` in place does not make sense

  // MARK: - Lshift

  private struct LshiftOp: BinaryOp {

    fileprivate static let op = "<<"
    fileprivate static let inPlaceOp = "<<="
    fileprivate static let selector = "__lshift__"
    fileprivate static let reverseSelector = "__rlshift__"
    fileprivate static let inPlaceSelector = "__ilshift__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __lshift__Owner {
        return owner.lshift(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rlshift__Owner {
        return owner.rlshift(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __ilshift__Owner {
        return owner.ilshift(right)
      }
      return .notImplemented
    }
  }

  public func lshift(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return LshiftOp.call(left: left, right: right)
  }

  public func lshiftInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return LshiftOp.callInPlace(left: left, right: right)
  }

  // MARK: - Rshift

  private struct RshiftOp: BinaryOp {

    fileprivate static let op = ">>"
    fileprivate static let inPlaceOp = ">>="
    fileprivate static let selector = "__rshift__"
    fileprivate static let reverseSelector = "__rrshift__"
    fileprivate static let inPlaceSelector = "__irshift__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __rshift__Owner {
        return owner.rshift(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rrshift__Owner {
        return owner.rrshift(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __irshift__Owner {
        return owner.irshift(right)
      }
      return .notImplemented
    }
  }

  public func rshift(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return RshiftOp.call(left: left, right: right)
  }

  public func rshiftInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return RshiftOp.callInPlace(left: left, right: right)
  }

  // MARK: - And

  private struct AndOp: BinaryOp {

    fileprivate static let op = "&"
    fileprivate static let inPlaceOp = "&="
    fileprivate static let selector = "__and__"
    fileprivate static let reverseSelector = "__rand__"
    fileprivate static let inPlaceSelector = "__iand__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __and__Owner {
        return owner.and(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rand__Owner {
        return owner.rand(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __iand__Owner {
        return owner.iand(right)
      }
      return .notImplemented
    }
  }

  public func and(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AndOp.call(left: left, right: right)
  }

  public func andInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AndOp.callInPlace(left: left, right: right)
  }

  // MARK: - Or

  private struct OrOp: BinaryOp {

    fileprivate static let op = "|"
    fileprivate static let inPlaceOp = "|="
    fileprivate static let selector = "__or__"
    fileprivate static let reverseSelector = "__ror__"
    fileprivate static let inPlaceSelector = "__ior__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __or__Owner {
        return owner.or(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __ror__Owner {
        return owner.ror(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __ior__Owner {
        return owner.ior(right)
      }
      return .notImplemented
    }
  }

  public func or(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return OrOp.call(left: left, right: right)
  }

  public func orInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return OrOp.callInPlace(left: left, right: right)
  }

  // MARK: - Xor

  private struct XorOp: BinaryOp {

    fileprivate static let op = "^"
    fileprivate static let inPlaceOp = "^="
    fileprivate static let selector = "__xor__"
    fileprivate static let reverseSelector = "__rxor__"
    fileprivate static let inPlaceSelector = "__ixor__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __xor__Owner {
        return owner.xor(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rxor__Owner {
        return owner.rxor(left)
      }
      return .notImplemented
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __ixor__Owner {
        return owner.ixor(right)
      }
      return .notImplemented
    }
  }

  public func xor(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return XorOp.call(left: left, right: right)
  }

  public func xorInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return XorOp.callInPlace(left: left, right: right)
  }
}
