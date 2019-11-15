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
  /// Python selector, for example `__add__`.
  static var selector: String { get }
  /// Python selector for reverse operation.
  /// For example for `__add__` it is `__radd__`.
  static var reverseSelector: String { get }
  /// Call op with fast protocol dispatch.
  static func callFastOp(left: PyObject,
                         right: PyObject) -> PyResultOrNot<PyObject>
  /// Call reverse op with fast protocol dispatch.
  /// For example for `__add__` it should call `__radd__`.
  static func callFastReverse(left: PyObject,
                              right: PyObject) -> PyResultOrNot<PyObject>
}

extension BinaryOp {

  /// static PyObject *
  /// binary_op1(PyObject *v, PyObject *w, const int op_slot)
  /// static PyObject *
  /// binary_op(PyObject *v, PyObject *w, const int op_slot, const char *op_name)
  fileprivate static func call(left: PyObject,
                               right: PyObject) -> PyResult<PyObject> {
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

    // Not hope left! We are doomed!
    return unsupported(left: left, right: right)
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
    case .noSuchMethod:
      return .notImplemented
    case .methodIsNotCallable(let e):
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
    case .noSuchMethod:
      return .notImplemented
    case .methodIsNotCallable(let e):
      return .error(e)
    }
  }

  /// static PyObject *
  /// binop_type_error(PyObject *v, PyObject *w, const char *op_name)
  /// static PyObject *
  /// binary_op(PyObject *v, PyObject *w, const int op_slot, const char *op_name)
  private static func unsupported(left: PyObject,
                                  right: PyObject) -> PyResult<PyObject> {
    let lt = left.typeName
    let rt = right.typeName

    var msg = "unsupported operand type(s) for \(Self.op): '\(lt)' and '\(rt)'."

    // For C++ programmers who try to `print << 'Elsa'`:
    if let fn = left as? PyBuiltinFunction, fn._name == "print", Self.op == "<<" {
      msg += " Did you mean \"print(<message>, file=<output_stream>)\"?"
    }

    return .typeError(msg)
  }
}

// MARK: - Builtins

extension Builtins {

  // MARK: - Add

  private struct AddOp: BinaryOp {

    fileprivate static let op = "+"
    fileprivate static let selector = "__add__"
    fileprivate static let reverseSelector = "__radd__"

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
  }

  public func add(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AddOp.call(left: left, right: right)
  }

  // MARK: - Sub

  private struct SubOp: BinaryOp {

    fileprivate static let op = "-"
    fileprivate static let selector = "__sub__"
    fileprivate static let reverseSelector = "__rsub__"

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
  }

  public func sub(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return SubOp.call(left: left, right: right)
  }

  // MARK: - Mul

  private struct MulOp: BinaryOp {

    fileprivate static let op = "*"
    fileprivate static let selector = "__mul__"
    fileprivate static let reverseSelector = "__rmul__"

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
  }

  public func mul(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return MulOp.call(left: left, right: right)
  }

  // MARK: - Div

  private struct DivOp: BinaryOp {

    fileprivate static let op = "/"
    fileprivate static let selector = "__div__"
    fileprivate static let reverseSelector = "__rdiv__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __truediv__Owner {
        return owner.trueDiv(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rtruediv__Owner {
        return owner.rtrueDiv(left)
      }
      return .notImplemented
    }
  }

  public func div(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return DivOp.call(left: left, right: right)
  }

  // MARK: - DivFloor

  private struct DivFloorOp: BinaryOp {

    fileprivate static let op = "//"
    fileprivate static let selector = "__divFloor__"
    fileprivate static let reverseSelector = "__rdivFloor__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __floordiv__Owner {
        return owner.floorDiv(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rfloordiv__Owner {
        return owner.rfloorDiv(left)
      }
      return .notImplemented
    }
  }

  public func divFloor(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return DivFloorOp.call(left: left, right: right)
  }

  // MARK: - Remainder

  private struct RemainderOp: BinaryOp {

    fileprivate static let op = "%"
    fileprivate static let selector = "__remainder__"
    fileprivate static let reverseSelector = "__rremainder__"

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
  }

  public func remainder(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return RemainderOp.call(left: left, right: right)
  }

  // MARK: - DivMod

  private struct DivModOp: BinaryOp {

    fileprivate static let op = "divmod()"
    fileprivate static let selector = "__divMod__"
    fileprivate static let reverseSelector = "__rdivMod__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __divmod__Owner {
        return owner.divMod(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rdivmod__Owner {
        return owner.rdivMod(left)
      }
      return .notImplemented
    }
  }

  public func divMod(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return DivModOp.call(left: left, right: right)
  }

  // MARK: - LShift

  private struct LShiftOp: BinaryOp {

    fileprivate static let op = "<<"
    fileprivate static let selector = "__lShift__"
    fileprivate static let reverseSelector = "__rlShift__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __lshift__Owner {
        return owner.lShift(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rlshift__Owner {
        return owner.rlShift(left)
      }
      return .notImplemented
    }
  }

  public func lShift(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return LShiftOp.call(left: left, right: right)
  }

  // MARK: - RShift

  private struct RShiftOp: BinaryOp {

    fileprivate static let op = ">>"
    fileprivate static let selector = "__rShift__"
    fileprivate static let reverseSelector = "__rrShift__"

    fileprivate static func callFastOp(left: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __rshift__Owner {
        return owner.rShift(right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = right as? __rrshift__Owner {
        return owner.rrShift(left)
      }
      return .notImplemented
    }
  }

  public func rShift(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return RShiftOp.call(left: left, right: right)
  }

  // MARK: - And

  private struct AndOp: BinaryOp {

    fileprivate static let op = "&"
    fileprivate static let selector = "__and__"
    fileprivate static let reverseSelector = "__rand__"

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
  }

  public func and(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return AndOp.call(left: left, right: right)
  }

  // MARK: - Or

  private struct OrOp: BinaryOp {

    fileprivate static let op = "|"
    fileprivate static let selector = "__or__"
    fileprivate static let reverseSelector = "__ror__"

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
  }

  public func or(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return OrOp.call(left: left, right: right)
  }

  // MARK: - Xor

  private struct XorOp: BinaryOp {

    fileprivate static let op = "^"
    fileprivate static let selector = "__xor__"
    fileprivate static let reverseSelector = "__rxor__"

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
  }

  public func xor(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    return XorOp.call(left: left, right: right)
  }
}
