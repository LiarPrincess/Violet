// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// MARK: - Abstract

private enum FastCallResult {
  case value(PyObject)
  case error(PyBaseException)
  /// Fast call is not available
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

/// Basically a template for ternary operations (even though we have only one).
/// See `BuiltinFunctions+Compare` for reasoning why we do it this way.
private protocol TernaryOp {

  /// Operator used to invoke given binary operation, for example '+'.
  /// Used for error messages.
  static var op: String { get }

  /// Python selector, for example `__pow__`.
  static var selector: String { get }
  /// Python selector for reflected operation.
  /// For `__pow__` it is `__rpow__`.
  static var reflectedSelector: String { get }

  /// Call op with fast protocol dispatch.
  static func callFastOp(left: PyObject,
                         middle: PyObject,
                         right: PyObject) -> FastCallResult
  /// Call reflected op with fast protocol dispatch.
  /// For `__pow__` it should call `__rpow__`.
  static func callFastReflected(left: PyObject,
                                middle: PyObject,
                                right: PyObject) -> FastCallResult
}

extension TernaryOp {

  fileprivate static func call(left: PyObject,
                               middle: PyObject,
                               right: PyObject) -> PyResult<PyObject> {
    var checkedReflected = false

    // Check if middle is subtype of left, if so then use middle.
    if left.type !== middle.type && middle.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch callReflected(left: left, middle: middle, right: right) {
      case .value(let result):
        if result.isNotImplemented {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left `op` middle, right (default path)
    switch callOp(left: left, middle: middle, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on middle
    if !checkedReflected {
      switch callReflected(left: left, middle: middle, right: right) {
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
    let operands = "\(left.typeName), \(middle.typeName) and \(right.typeName)"
    return .typeError("unsupported operand type(s) for \(op): \(operands).")
  }

  private static func callOp(left: PyObject,
                             middle: PyObject,
                             right: PyObject) -> PyResult<PyObject> {
    // Try fast protocol-based dispach
    switch callFastOp(left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(on: left, selector: selector, args: [middle, right]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  private static func callReflected(left: PyObject,
                                    middle: PyObject,
                                    right: PyObject) -> PyResult<PyObject> {
    // Try fast protocol-based dispach
    switch callFastReflected(left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try other options...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(on: middle, selector: reflectedSelector, args: [left, right]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}

// MARK: - Pow

private enum PowOp: TernaryOp {
  fileprivate static var op = "** or pow()"
  fileprivate static var selector = "__pow__"
  fileprivate static var reflectedSelector = "__rpow__"

  fileprivate static func callFastOp(left: PyObject,
                                     middle: PyObject,
                                     right: PyObject) -> FastCallResult {
    if let owner = left as? __pow__Owner {
      return FastCallResult(owner.pow(exp: middle, mod: right))
    }
    return .unavailable
  }

  fileprivate static func callFastReflected(left: PyObject,
                                            middle: PyObject,
                                            right: PyObject) -> FastCallResult {
    if let owner = middle as? __rpow__Owner {
      return FastCallResult(owner.rpow(base: left, mod: right))
    }
    return .unavailable
  }
}

extension BuiltinFunctions {

  // sourcery: pymethod = pow
  /// pow(base, exp[, mod])
  /// See [this](https://docs.python.org/3/library/functions.html#pow)
  public func pow(base: PyObject,
                  exp: PyObject,
                  mod: PyObject? = nil) -> PyResult<PyObject> {
    let mod = mod ?? Py.none
    return PowOp.call(left: base, middle: exp, right: mod)
  }
}
