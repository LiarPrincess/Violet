// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// A lot of the code in this file was generated using:
// './Scripts/generate_module_funcs/generate-builtins-binary.py'

// swiftlint:disable file_length

// MARK: - Abstract

private enum FastCallResult {
  case value(PyObject)
  case error(PyErrorEnum)
  case unavailable

  fileprivate init(_ value: PyResult<PyObject>) {
    switch value {
    case .value(let o):
      self = .value(o)
    case .error(let e):
      self = .error(e)
    }
  }
}

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
                         right: PyObject) -> FastCallResult
  /// Call reverse op with fast protocol dispatch.
  /// For `__add__` it should call `__radd__`.
  static func callFastReverse(left: PyObject,
                              right: PyObject) -> FastCallResult
  /// Call in-place op with fast protocol dispatch.
  /// For `__add__` it should call `__iadd__`.
  static func callFastInPlace(left: PyObject,
                              right: PyObject) -> FastCallResult
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
      if result.isNotImplemented {
        let lt = left.typeName
        let rt = right.typeName
        var msg = "unsupported operand type(s) for \(op): '\(lt)' and '\(rt)'."

        // For C++ programmers who try to `print << 'Elsa'`:
        if let fn = left as? PyBuiltinFunction, fn.name == "print", Self.op == "<<" {
          msg += " Did you mean \"print(<message>, file=<output_stream>)\"?"
        }

        return .typeError(msg)
      }

      return .value(result)

    case .error(let e):
      return .error(e)
    }
  }

  fileprivate static func callInPlace(left: PyObject,
                                      right: PyObject) -> PyResult<PyObject> {
    switch callInPlaceInner(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        break // try other options
      }

      return .value(result)

    case .error(let e):
      return .error(e)
    }

    // Try standard operation, for example '+'
    switch callInner(left: left, right: right, operation: op) {
    case .value(let result):
      if result.isNotImplemented {
        let lt = left.typeName
        let rt = right.typeName
        let msg = "unsupported operand type(s) for \(inPlaceOp): '\(lt)' and '\(rt)'."
        return .typeError(msg)
      }

      return .value(result)

    case .error(let e):
      return .error(e)
    }
  }

  /// static PyObject *
  /// binary_op1(PyObject *v, PyObject *w, const int op_slot)
  /// static PyObject *
  /// binary_op(PyObject *v, PyObject *w, const int op_slot, const char *op_name)
  fileprivate static func callInner(left: PyObject,
                                    right: PyObject,
                                    operation: String) -> PyResult<PyObject> {
    var checkedReverse = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReverse = true

      switch callReverse(left: left, right: right) {
      case .value(let result):
        if result.isNotImplemented {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left `op` right (default path)
    switch callOp(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reverse on right
    if !checkedReverse {
      switch callReverse(left: left, right: right) {
      case .value(let result):
        if result.isNotImplemented {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    let builtins = left.context.builtins
    return .value(builtins.notImplemented)
  }

  private static func callOp(left: PyObject,
                             right: PyObject) -> PyResult<PyObject> {
    let builtins = left.context.builtins

    // Try fast protocol-based dispach
    switch callFastOp(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch builtins.callMethod(on: left, selector: selector, arg: right) {
    case .value(let result):
      return .value(result)
    case .missingMethod, .notImplemented:
      return .value(left.builtins.notImplemented)
    case .notCallable(let e), .error(let e):
      return .error(e)
    }
  }

  private static func callReverse(left: PyObject,
                                  right: PyObject) -> PyResult<PyObject> {
    let builtins = left.context.builtins

    // Try fast protocol-based dispach
    switch callFastReverse(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch builtins.callMethod(on: right, selector: reverseSelector, arg: left) {
    case .value(let result):
      return .value(result)
    case .missingMethod, .notImplemented:
      return .value(builtins.notImplemented)
    case .notCallable(let e), .error(let e):
      return .error(e)
    }
  }

  private static func callInPlaceInner(left: PyObject,
                                       right: PyObject) -> PyResult<PyObject> {
    let builtins = left.context.builtins

    // Try fast protocol-based dispach
    switch callFastInPlace(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch builtins.callMethod(on: left, selector: inPlaceSelector, arg: right) {
    case .value(let result):
      return .value(result)
    case .missingMethod, .notImplemented:
      return .value(builtins.notImplemented)
    case .notCallable(let e), .error(let e):
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __add__Owner {
        return FastCallResult(owner.add(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __radd__Owner {
        return FastCallResult(owner.radd(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __iadd__Owner {
        return FastCallResult(owner.iadd(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __sub__Owner {
        return FastCallResult(owner.sub(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rsub__Owner {
        return FastCallResult(owner.rsub(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __isub__Owner {
        return FastCallResult(owner.isub(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __mul__Owner {
        return FastCallResult(owner.mul(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rmul__Owner {
        return FastCallResult(owner.rmul(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __imul__Owner {
        return FastCallResult(owner.imul(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __matmul__Owner {
        return FastCallResult(owner.matmul(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rmatmul__Owner {
        return FastCallResult(owner.rmatmul(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __imatmul__Owner {
        return FastCallResult(owner.imatmul(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __truediv__Owner {
        return FastCallResult(owner.truediv(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rtruediv__Owner {
        return FastCallResult(owner.rtruediv(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __itruediv__Owner {
        return FastCallResult(owner.itruediv(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __floordiv__Owner {
        return FastCallResult(owner.floordiv(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rfloordiv__Owner {
        return FastCallResult(owner.rfloordiv(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __ifloordiv__Owner {
        return FastCallResult(owner.ifloordiv(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __mod__Owner {
        return FastCallResult(owner.mod(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rmod__Owner {
        return FastCallResult(owner.rmod(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __imod__Owner {
        return FastCallResult(owner.imod(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __divmod__Owner {
        return FastCallResult(owner.divmod(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rdivmod__Owner {
        return FastCallResult(owner.rdivmod(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      return .unavailable
    }
  }

  // sourcery: pymethod = divmod
  /// divmod(a, b)
  /// See [this](https://docs.python.org/3/library/functions.html#divmod)
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __lshift__Owner {
        return FastCallResult(owner.lshift(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rlshift__Owner {
        return FastCallResult(owner.rlshift(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __ilshift__Owner {
        return FastCallResult(owner.ilshift(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __rshift__Owner {
        return FastCallResult(owner.rshift(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rrshift__Owner {
        return FastCallResult(owner.rrshift(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __irshift__Owner {
        return FastCallResult(owner.irshift(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __and__Owner {
        return FastCallResult(owner.and(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rand__Owner {
        return FastCallResult(owner.rand(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __iand__Owner {
        return FastCallResult(owner.iand(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __or__Owner {
        return FastCallResult(owner.or(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __ror__Owner {
        return FastCallResult(owner.ror(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __ior__Owner {
        return FastCallResult(owner.ior(right))
      }
      return .unavailable
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
                                       right: PyObject) -> FastCallResult {
      if let owner = left as? __xor__Owner {
        return FastCallResult(owner.xor(right))
      }
      return .unavailable
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = right as? __rxor__Owner {
        return FastCallResult(owner.rxor(left))
      }
      return .unavailable
    }

    fileprivate static func callFastInPlace(left: PyObject,
                                            right: PyObject) -> FastCallResult {
      if let owner = left as? __ixor__Owner {
        return FastCallResult(owner.ixor(right))
      }
      return .unavailable
    }
  }

  public func xor(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return XorOp.call(left: left, right: right)
  }

  public func xorInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return XorOp.callInPlace(left: left, right: right)
  }
}
