// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// MARK: - Abstract

/// Basically a template for ternary operations (even though we have only one).
/// See `Builtins+Compare` for reasoning why we do it this way.
private protocol TernaryOp {

  /// Operator used to invoke given binary operation, for example '+'.
  /// Used for error messages.
  static var op: String { get }

  /// Python selector, for example `__pow__`.
  static var selector: String { get }
  /// Python selector for reverse operation.
  /// For `__pow__` it is `__rpow__`.
  static var reverseSelector: String { get }

  /// Call op with fast protocol dispatch.
  static func callFastOp(left: PyObject,
                         middle: PyObject,
                         right: PyObject) -> PyResultOrNot<PyObject>
  /// Call reverse op with fast protocol dispatch.
  /// For `__pow__` it should call `__rpow__`.
  static func callFastReverse(left: PyObject,
                              middle: PyObject,
                              right: PyObject) -> PyResultOrNot<PyObject>
}

extension TernaryOp {

  fileprivate static func call(left: PyObject,
                               middle: PyObject,
                               right: PyObject) -> PyResult<PyObject> {

    var checkedReverse = false

    // Check if middle is subtype of left, if so then use middle.
    if left.type !== middle.type && middle.type.isSubtype(of: left.type) {
      checkedReverse = true

      switch callReverse(left: left, middle: middle, right: right) {
      case .value(let result): return .value(result)
      case .error(let e): return .error(e)
      case .notImplemented: break
      }
    }

    // Try left `op` middle, right (default path)
    switch callOp(left: left, middle: middle, right: right) {
    case .value(let result): return .value(result)
    case .error(let e): return .error(e)
    case .notImplemented: break
    }

    // Try reverse on middle
    if !checkedReverse {
      switch callReverse(left: left, middle: middle, right: right) {
      case .value(let result): return .value(result)
      case .error(let e): return .error(e)
      case .notImplemented: break
      }
    }

    // No hope left! We are doomed!
    let lt = left.typeName
    let rt = right.typeName
    return .typeError("unsupported operand type(s) for \(op): '\(lt)' and '\(rt)'.")
  }

  private static func callOp(left: PyObject,
                             middle: PyObject,
                             right: PyObject) -> PyResultOrNot<PyObject> {
    let builtins = left.context.builtins

    // Try fast protocol-based dispach
    switch callFastOp(left: left, middle: middle, right: right) {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .notImplemented:
      break // Try other options...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch builtins.callMethod(on: left, selector: selector, args: [middle, right]) {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .missingMethod, .notImplemented:
      return .notImplemented
    case .notCallable(let e), .error(let e):
      return .error(e)
    }
  }

  private static func callReverse(left: PyObject,
                                  middle: PyObject,
                                  right: PyObject) -> PyResultOrNot<PyObject> {
    let builtins = left.context.builtins

    // Try fast protocol-based dispach
    switch callFastReverse(left: left, middle: middle, right: right) {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .notImplemented:
      break // Try other options...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch builtins.callMethod(on: middle, selector: reverseSelector, args: [left, right]) {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .missingMethod, .notImplemented:
      return .notImplemented
    case .notCallable(let e), .error(let e):
      return .error(e)
    }
  }
}

// MARK: - Builtins

extension Builtins {

  // MARK: - Pow

  private enum PowOp: TernaryOp {
    fileprivate static var op = "** or pow()"
    fileprivate static var selector = "__pow__"
    fileprivate static var reverseSelector = "__rpow__"

    fileprivate static func callFastOp(left: PyObject,
                                       middle: PyObject,
                                       right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = left as? __pow__Owner {
        return owner.pow(exp: middle, mod: right)
      }
      return .notImplemented
    }

    fileprivate static func callFastReverse(left: PyObject,
                                            middle: PyObject,
                                            right: PyObject) -> PyResultOrNot<PyObject> {
      if let owner = middle as? __rpow__Owner {
        return owner.rpow(base: left, mod: right)
      }
      return .notImplemented
    }
  }

  // sourcery: pymethod: pow
  /// pow(base, exp[, mod])
  /// See [this](https://docs.python.org/3/library/functions.html#pow)
  public func pow(base: PyObject,
                  exp: PyObject,
                  mod: PyObject? = nil) -> PyResultOrNot<PyObject> {
    let mod = mod ?? self.none
    return PowOp.callFastOp(left: base, middle: exp, right: mod)
  }
}
