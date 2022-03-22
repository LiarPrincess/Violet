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

  fileprivate init(_ value: PyResult?) {
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
  static func callStatic(_ py: Py, left: PyObject, right: PyObject) -> StaticCallResult
  /// Fast path: we know the reflected method at compile time
  ///
  /// For `__add__` it should call `__radd__`.
  static func callStaticReflected(_ py: Py, left: PyObject, right: PyObject) -> StaticCallResult
  /// Fast path: we know the in-place method at compile time
  ///
  /// For `__add__` it should call `__iadd__`.
  static func callStaticInPlace(_ py: Py, left: PyObject, right: PyObject) -> StaticCallResult
}

extension BinaryOp {

  // MARK: Call

  /// static PyObject *
  /// binary_op1(PyObject *v, PyObject *w, const int op_slot)
  /// static PyObject *
  /// binary_op(PyObject *v, PyObject *w, const int op_slot, const char *op_name)
  /// define SLOT1BINFULL(FUNCNAME, TESTFUNC, SLOTNAME, OPSTR, ROPSTR)
  fileprivate static func call(_ py: Py,
                               left: PyObject,
                               right: PyObject) -> PyResult {
    switch self.callInner(py, left: left, right: right) {
    case let .value(result):
      if py.cast.isNotImplemented(result) {
        let leftType = left.typeName
        let rightType = right.typeName
        var msg = "unsupported operand type(s) for \(op): '\(leftType)' and '\(rightType)'"

        // For C++ programmers who try to `print << 'Elsa'`:
        if let fn = py.cast.asBuiltinFunction(left),
           fn.name == "print",
           Self.op == "<<" {
          msg += " Did you mean \"print(<message>, file=<output_stream>)\"?"
        }

        return .typeError(py, message: msg)
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: Call in place

  fileprivate static func callInPlace(_ py: Py,
                                      left: PyObject,
                                      right: PyObject) -> PyResult {
    switch self.callInPlaceOp(py, left: left, right: right) {
    case let .value(result):
      if py.cast.isNotImplemented(result) {
        break // try other options
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }

    // Try standard operation, for example '+'
    switch self.callInner(py, left: left, right: right) {
    case let .value(result):
      if py.cast.isNotImplemented(result) {
        let leftType = left.typeName
        let rightType = right.typeName
        let msg = "unsupported operand type(s) for \(inPlaceOp): \(leftType) and \(rightType)."
        return .typeError(py, message: msg)
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
  fileprivate static func callInner(_ py: Py,
                                    left: PyObject,
                                    right: PyObject) -> PyResult {
    var checkedReflected = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch self.callReflectedOp(py, left: left, right: right) {
      case .value(let result):
        if py.cast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left `op` right (default path)
    switch self.callOp(py, left: left, right: right) {
    case .value(let result):
      if py.cast.isNotImplemented(result) {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on right
    if !checkedReflected {
      switch self.callReflectedOp(py, left: left, right: right) {
      case .value(let result):
        if py.cast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    return .notImplemented(py)
  }

  // MARK: Call op

  private static func callOp(_ py: Py,
                             left: PyObject,
                             right: PyObject) -> PyResult {
    // Fast path: we know the method at compile time
    switch self.callStatic(py, left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch py.callMethod(object: left, selector: selector, arg: right) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(py)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func callReflectedOp(_ py: Py,
                                      left: PyObject,
                                      right: PyObject) -> PyResult {
    // Fast path: we know the method at compile time
    switch self.callStaticReflected(py, left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch py.callMethod(object: right, selector: reflectedSelector, arg: left) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(py)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func callInPlaceOp(_ py: Py,
                                    left: PyObject,
                                    right: PyObject) -> PyResult {
    // Fast path: we know the method at compile time
    switch self.callStaticInPlace(py, left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch py.callMethod(object: left, selector: inPlaceSelector, arg: right) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(py)
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

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__add__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__radd__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__iadd__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func add(left: PyObject, right: PyObject) -> PyResult {
    return AddOp.call(self, left: left, right: right)
  }

  public func addInPlace(left: PyObject, right: PyObject) -> PyResult {
    return AddOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Sub

private struct SubOp: BinaryOp {

  fileprivate static let op = "-"
  fileprivate static let inPlaceOp = "-="
  fileprivate static let selector = IdString.__sub__
  fileprivate static let reflectedSelector = IdString.__rsub__
  fileprivate static let inPlaceSelector = IdString.__isub__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__sub__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rsub__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__isub__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func sub(left: PyObject, right: PyObject) -> PyResult {
    return SubOp.call(self, left: left, right: right)
  }

  public func subInPlace(left: PyObject, right: PyObject) -> PyResult {
    return SubOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Mul

private struct MulOp: BinaryOp {

  fileprivate static let op = "*"
  fileprivate static let inPlaceOp = "*="
  fileprivate static let selector = IdString.__mul__
  fileprivate static let reflectedSelector = IdString.__rmul__
  fileprivate static let inPlaceSelector = IdString.__imul__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__mul__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rmul__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__imul__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func mul(left: PyObject, right: PyObject) -> PyResult {
    return MulOp.call(self, left: left, right: right)
  }

  public func mulInPlace(left: PyObject, right: PyObject) -> PyResult {
    return MulOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Matmul

private struct MatmulOp: BinaryOp {

  fileprivate static let op = "@"
  fileprivate static let inPlaceOp = "@="
  fileprivate static let selector = IdString.__matmul__
  fileprivate static let reflectedSelector = IdString.__rmatmul__
  fileprivate static let inPlaceSelector = IdString.__imatmul__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__matmul__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rmatmul__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__imatmul__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func matmul(left: PyObject, right: PyObject) -> PyResult {
    return MatmulOp.call(self, left: left, right: right)
  }

  public func matmulInPlace(left: PyObject, right: PyObject) -> PyResult {
    return MatmulOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Truediv

private struct TrueDivOp: BinaryOp {

  fileprivate static let op = "/"
  fileprivate static let inPlaceOp = "/="
  fileprivate static let selector = IdString.__truediv__
  fileprivate static let reflectedSelector = IdString.__rtruediv__
  fileprivate static let inPlaceSelector = IdString.__itruediv__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__truediv__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rtruediv__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__itruediv__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func trueDiv(left: PyObject, right: PyObject) -> PyResult {
    return TrueDivOp.call(self, left: left, right: right)
  }

  public func trueDivInPlace(left: PyObject, right: PyObject) -> PyResult {
    return TrueDivOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Floordiv

private struct FloorDivOp: BinaryOp {

  fileprivate static let op = "//"
  fileprivate static let inPlaceOp = "//="
  fileprivate static let selector = IdString.__floordiv__
  fileprivate static let reflectedSelector = IdString.__rfloordiv__
  fileprivate static let inPlaceSelector = IdString.__ifloordiv__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__floordiv__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rfloordiv__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ifloordiv__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func floorDiv(left: PyObject, right: PyObject) -> PyResult {
    return FloorDivOp.call(self, left: left, right: right)
  }

  public func floorDivInPlace(left: PyObject, right: PyObject) -> PyResult {
    return FloorDivOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Mod

private struct ModOp: BinaryOp {

  fileprivate static let op = "%"
  fileprivate static let inPlaceOp = "%="
  fileprivate static let selector = IdString.__mod__
  fileprivate static let reflectedSelector = IdString.__rmod__
  fileprivate static let inPlaceSelector = IdString.__imod__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__mod__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rmod__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__imod__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func mod(left: PyObject, right: PyObject) -> PyResult {
    return ModOp.call(self, left: left, right: right)
  }

  public func modInPlace(left: PyObject, right: PyObject) -> PyResult {
    return ModOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Divmod

private struct DivModOp: BinaryOp {

  fileprivate static let op = "divmod()"
  fileprivate static let inPlaceOp = "divmod()="
  fileprivate static let selector = IdString.__divmod__
  fileprivate static let reflectedSelector = IdString.__rdivmod__
  fileprivate static let inPlaceSelector = IdString.__idivmod__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__divmod__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rdivmod__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__idivmod__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  /// divmod(a, b)
  /// See [this](https://docs.python.org/3/library/functions.html#divmod)
  public func divMod(left: PyObject, right: PyObject) -> PyResult {
    return DivModOp.call(self, left: left, right: right)
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

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__lshift__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rlshift__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ilshift__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func lshift(left: PyObject, right: PyObject) -> PyResult {
    return LshiftOp.call(self, left: left, right: right)
  }

  public func lshiftInPlace(left: PyObject, right: PyObject) -> PyResult {
    return LshiftOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Rshift

private struct RshiftOp: BinaryOp {

  fileprivate static let op = ">>"
  fileprivate static let inPlaceOp = ">>="
  fileprivate static let selector = IdString.__rshift__
  fileprivate static let reflectedSelector = IdString.__rrshift__
  fileprivate static let inPlaceSelector = IdString.__irshift__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rshift__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rrshift__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__irshift__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func rshift(left: PyObject, right: PyObject) -> PyResult {
    return RshiftOp.call(self, left: left, right: right)
  }

  public func rshiftInPlace(left: PyObject, right: PyObject) -> PyResult {
    return RshiftOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - And

private struct AndOp: BinaryOp {

  fileprivate static let op = "&"
  fileprivate static let inPlaceOp = "&="
  fileprivate static let selector = IdString.__and__
  fileprivate static let reflectedSelector = IdString.__rand__
  fileprivate static let inPlaceSelector = IdString.__iand__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__and__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rand__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__iand__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func and(left: PyObject, right: PyObject) -> PyResult {
    return AndOp.call(self, left: left, right: right)
  }

  public func andInPlace(left: PyObject, right: PyObject) -> PyResult {
    return AndOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Or

private struct OrOp: BinaryOp {

  fileprivate static let op = "|"
  fileprivate static let inPlaceOp = "|="
  fileprivate static let selector = IdString.__or__
  fileprivate static let reflectedSelector = IdString.__ror__
  fileprivate static let inPlaceSelector = IdString.__ior__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__or__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ror__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ior__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func or(left: PyObject, right: PyObject) -> PyResult {
    return OrOp.call(self, left: left, right: right)
  }

  public func orInPlace(left: PyObject, right: PyObject) -> PyResult {
    return OrOp.callInPlace(self, left: left, right: right)
  }
}

// MARK: - Xor

private struct XorOp: BinaryOp {

  fileprivate static let op = "^"
  fileprivate static let inPlaceOp = "^="
  fileprivate static let selector = IdString.__xor__
  fileprivate static let reflectedSelector = IdString.__rxor__
  fileprivate static let inPlaceSelector = IdString.__ixor__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__xor__(py, left: left, right: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rxor__(py, left: right, right: left)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ixor__(py, left: left, right: right)
    return StaticCallResult(result)
  }
}

extension Py {

  public func xor(left: PyObject, right: PyObject) -> PyResult {
    return XorOp.call(self, left: left, right: right)
  }

  public func xorInPlace(left: PyObject, right: PyObject) -> PyResult {
    return XorOp.callInPlace(self, left: left, right: right)
  }
}
