// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// A lot of the code in this file was generated using:
// './Scripts/builtins_generate_binary_operations_code'

// swiftlint:disable file_length
// cSpell:ignore BINFULL TESTFUNC SLOTNAME OPSTR ROPSTR

// MARK: - Abstract

private enum StaticCallResult {
  case value(PyObject)
  case error(PyBaseException)
  /// Static call is not available
  case unavailable

  fileprivate init(_ value: PyResult<PyObject>?) {
    guard let v = value else {
      self = .unavailable
      return
    }

    switch v {
    case .value(let o):
      self = .value(o)
    case .error(let e):
      self = .error(e)
    }
  }
}

/// Basically a template for binary operations.
/// See `Py+Compare` for reasoning why we do it this way.
private protocol BinaryOp {

  /// Operator used to invoke given binary operation, for example '+'.
  /// Used for error messages.
  static var op: String { get }
  /// Operator used to invoke given binary operation, for example '+='.
  /// Used for error messages.
  static var inPlaceOp: String { get }

  /// Python selector, for example `__add__`.
  static var selector: IdString { get }
  /// Python selector for reflected operation.
  /// For `__add__` it is `__radd__`.
  static var reflectedSelector: IdString { get }
  /// Python selector for in-place operation.
  /// For `__add__` it is `__iadd__`.
  static var inPlaceSelector: IdString { get }

  /// Fast path: we know the method at compile time
  static func callStatic(left: PyObject, right: PyObject) -> StaticCallResult
  /// Fast path: we know the reflected method at compile time
  ///
  /// For `__add__` it should call `__radd__`.
  static func callStaticReflected(left: PyObject, right: PyObject) -> StaticCallResult
  /// Fast path: we know the in-place method at compile time
  ///
  /// For `__add__` it should call `__iadd__`.
  static func callStaticInPlace(left: PyObject, right: PyObject) -> StaticCallResult
}

extension BinaryOp {

  // MARK: Call

  /// static PyObject *
  /// binary_op1(PyObject *v, PyObject *w, const int op_slot)
  /// static PyObject *
  /// binary_op(PyObject *v, PyObject *w, const int op_slot, const char *op_name)
  /// define SLOT1BINFULL(FUNCNAME, TESTFUNC, SLOTNAME, OPSTR, ROPSTR)
  fileprivate static func call(left: PyObject,
                               right: PyObject) -> PyResult<PyObject> {
    switch self.callInner(left: left, right: right) {
    case let .value(result):
      if PyCast.isNotImplemented(result) {
        let leftType = left.typeName
        let rightType = right.typeName
        var msg = "unsupported operand type(s) for \(op): \(leftType) and \(rightType)."

        // For C++ programmers who try to `print << 'Elsa'`:
        if let fn = PyCast.asBuiltinFunction(left),
           fn.name == "print",
           Self.op == "<<" {
          msg += " Did you mean \"print(<message>, file=<output_stream>)\"?"
        }

        return .typeError(msg)
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: Call in place

  fileprivate static func callInPlace(left: PyObject,
                                      right: PyObject) -> PyResult<PyObject> {
    switch self.callInPlaceOp(left: left, right: right) {
    case let .value(result):
      if PyCast.isNotImplemented(result) {
        break // try other options
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }

    // Try standard operation, for example '+'
    switch self.callInner(left: left, right: right) {
    case let .value(result):
      if PyCast.isNotImplemented(result) {
        let msg = "unsupported operand type(s) for \(inPlaceOp): " +
          "\(left.typeName) and \(right.typeName)."
        return .typeError(msg)
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  /// Standard operation call.
  /// Basically code shared between normal and in-place call.
  ///
  /// static PyObject *
  /// binary_op1(PyObject *v, PyObject *w, const int op_slot)
  /// static PyObject *
  /// binary_op(PyObject *v, PyObject *w, const int op_slot, const char *op_name)
  fileprivate static func callInner(left: PyObject,
                                    right: PyObject) -> PyResult<PyObject> {
    var checkedReflected = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch self.callReflectedOp(left: left, right: right) {
      case .value(let result):
        if PyCast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left `op` right (default path)
    switch self.callOp(left: left, right: right) {
    case .value(let result):
      if PyCast.isNotImplemented(result) {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on right
    if !checkedReflected {
      switch self.callReflectedOp(left: left, right: right) {
      case .value(let result):
        if PyCast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    return .value(Py.notImplemented)
  }

  // MARK: Call op

  private static func callOp(left: PyObject,
                             right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStatic(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(object: left, selector: selector, arg: right) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func callReflectedOp(left: PyObject,
                                      right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStaticReflected(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(object: right, selector: reflectedSelector, arg: left) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func callInPlaceOp(left: PyObject,
                                    right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStaticInPlace(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(object: left, selector: inPlaceSelector, arg: right) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}

// MARK: - Add

private struct AddOp: BinaryOp {

  fileprivate static let op = "+"
  fileprivate static let inPlaceOp = "+="
  fileprivate static let selector = IdString.__add__
  fileprivate static let reflectedSelector = IdString.__radd__
  fileprivate static let inPlaceSelector = IdString.__iadd__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__add__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__radd__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__iadd__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func add(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AddOp.call(left: left, right: right)
  }

  public func addInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AddOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Sub

private struct SubOp: BinaryOp {

  fileprivate static let op = "-"
  fileprivate static let inPlaceOp = "-="
  fileprivate static let selector = IdString.__sub__
  fileprivate static let reflectedSelector = IdString.__rsub__
  fileprivate static let inPlaceSelector = IdString.__isub__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__sub__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rsub__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__isub__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func sub(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return SubOp.call(left: left, right: right)
  }

  public func subInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return SubOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Mul

private struct MulOp: BinaryOp {

  fileprivate static let op = "*"
  fileprivate static let inPlaceOp = "*="
  fileprivate static let selector = IdString.__mul__
  fileprivate static let reflectedSelector = IdString.__rmul__
  fileprivate static let inPlaceSelector = IdString.__imul__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__mul__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rmul__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__imul__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func mul(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MulOp.call(left: left, right: right)
  }

  public func mulInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MulOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Matmul

private struct MatmulOp: BinaryOp {

  fileprivate static let op = "@"
  fileprivate static let inPlaceOp = "@="
  fileprivate static let selector = IdString.__matmul__
  fileprivate static let reflectedSelector = IdString.__rmatmul__
  fileprivate static let inPlaceSelector = IdString.__imatmul__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__matmul__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rmatmul__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__imatmul__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func matmul(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MatmulOp.call(left: left, right: right)
  }

  public func matmulInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MatmulOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Truediv

private struct TruedivOp: BinaryOp {

  fileprivate static let op = "/"
  fileprivate static let inPlaceOp = "/="
  fileprivate static let selector = IdString.__truediv__
  fileprivate static let reflectedSelector = IdString.__rtruediv__
  fileprivate static let inPlaceSelector = IdString.__itruediv__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__truediv__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rtruediv__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__itruediv__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func truediv(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return TruedivOp.call(left: left, right: right)
  }

  public func truedivInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return TruedivOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Floordiv

private struct FloordivOp: BinaryOp {

  fileprivate static let op = "//"
  fileprivate static let inPlaceOp = "//="
  fileprivate static let selector = IdString.__floordiv__
  fileprivate static let reflectedSelector = IdString.__rfloordiv__
  fileprivate static let inPlaceSelector = IdString.__ifloordiv__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__floordiv__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rfloordiv__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ifloordiv__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func floordiv(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return FloordivOp.call(left: left, right: right)
  }

  public func floordivInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return FloordivOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Mod

private struct ModOp: BinaryOp {

  fileprivate static let op = "%"
  fileprivate static let inPlaceOp = "%="
  fileprivate static let selector = IdString.__mod__
  fileprivate static let reflectedSelector = IdString.__rmod__
  fileprivate static let inPlaceSelector = IdString.__imod__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__mod__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rmod__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__imod__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func mod(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return ModOp.call(left: left, right: right)
  }

  public func modInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return ModOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Divmod

private struct DivmodOp: BinaryOp {

  fileprivate static let op = "divmod()"
  fileprivate static let inPlaceOp = "divmod()="
  fileprivate static let selector = IdString.__divmod__
  fileprivate static let reflectedSelector = IdString.__rdivmod__
  fileprivate static let inPlaceSelector = IdString.__idivmod__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__divmod__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rdivmod__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__idivmod__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  /// divmod(a, b)
  /// See [this](https://docs.python.org/3/library/functions.html#divmod)
  public func divmod(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return DivmodOp.call(left: left, right: right)
  }

  // `divmod` in place does not make sense
}

// MARK: - Lshift

private struct LshiftOp: BinaryOp {

  fileprivate static let op = "<<"
  fileprivate static let inPlaceOp = "<<="
  fileprivate static let selector = IdString.__lshift__
  fileprivate static let reflectedSelector = IdString.__rlshift__
  fileprivate static let inPlaceSelector = IdString.__ilshift__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__lshift__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rlshift__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ilshift__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func lshift(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return LshiftOp.call(left: left, right: right)
  }

  public func lshiftInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return LshiftOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Rshift

private struct RshiftOp: BinaryOp {

  fileprivate static let op = ">>"
  fileprivate static let inPlaceOp = ">>="
  fileprivate static let selector = IdString.__rshift__
  fileprivate static let reflectedSelector = IdString.__rrshift__
  fileprivate static let inPlaceSelector = IdString.__irshift__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rshift__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rrshift__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__irshift__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func rshift(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return RshiftOp.call(left: left, right: right)
  }

  public func rshiftInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return RshiftOp.callInPlace(left: left, right: right)
  }
}

// MARK: - And

private struct AndOp: BinaryOp {

  fileprivate static let op = "&"
  fileprivate static let inPlaceOp = "&="
  fileprivate static let selector = IdString.__and__
  fileprivate static let reflectedSelector = IdString.__rand__
  fileprivate static let inPlaceSelector = IdString.__iand__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__and__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rand__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__iand__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func and(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AndOp.call(left: left, right: right)
  }

  public func andInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AndOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Or

private struct OrOp: BinaryOp {

  fileprivate static let op = "|"
  fileprivate static let inPlaceOp = "|="
  fileprivate static let selector = IdString.__or__
  fileprivate static let reflectedSelector = IdString.__ror__
  fileprivate static let inPlaceSelector = IdString.__ior__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__or__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ror__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ior__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func or(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return OrOp.call(left: left, right: right)
  }

  public func orInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return OrOp.callInPlace(left: left, right: right)
  }
}

// MARK: - Xor

private struct XorOp: BinaryOp {

  fileprivate static let op = "^"
  fileprivate static let inPlaceOp = "^="
  fileprivate static let selector = IdString.__xor__
  fileprivate static let reflectedSelector = IdString.__rxor__
  fileprivate static let inPlaceSelector = IdString.__ixor__

  fileprivate static func callStatic(left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__xor__(left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rxor__(left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ixor__(left: left, right: right)
    return StaticCallResult(result)
  }
}

extension PyInstance {

  public func xor(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return XorOp.call(left: left, right: right)
  }

  public func xorInPlace(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return XorOp.callInPlace(left: left, right: right)
  }
}
